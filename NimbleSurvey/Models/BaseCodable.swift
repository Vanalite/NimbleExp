//
//  BaseCodable.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RealmSwift

struct BaseCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(intValue: Int) {
        stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }
}

var customUserInfo = ThreadSafeDictionary<CodingUserInfoKey, Any>()

extension Decoder {
    func value<T>(from key: CodingUserInfoKey) -> T? {
        (userInfo[key] as? T) ?? (customUserInfo[key] as? T)
    }

    func setValue(_ value: Any?, forKey key: CodingUserInfoKey) {
        customUserInfo[key] = value
    }
}

enum BaseCodableError: Error {
    case noRequiredKey
}

typealias BaseCodableProtocol = BaseEncodableProtocol & Decodable

class BaseCodable: Object, BaseCodableProtocol {
    @objc dynamic var dummyId: Int = 0

    var manualKeys: [String] {
        []
    }

    override required init() {
        super.init()
    }

    func encode(to encoder: Encoder) throws {
    }

    private func lowerProperty(property: String) -> BaseCodingKey? {
        let splitted = property
            .map { String($0) }

        var lowers: [String] = []

        splitted.forEach { text in
            lowers.append(text.lowercased())
        }

        return BaseCodingKey(stringValue: lowers.joined(separator: "_"))
    }

    private func decodeString(
        container: KeyedDecodingContainer<BaseCodingKey>,
        key: BaseCodingKey,
        isOptional: Bool
    ) -> String? {
        let value: String?

        if let data = try? container.decode(String.self, forKey: key) {
            value = data
        } else if let data = try? container.decode(Int.self, forKey: key) {
            value = "\(data)"
        } else if let data = try? container.decode(Int64.self, forKey: key) {
            value = "\(data)"
        } else if let data = try? container.decode(Double.self, forKey: key) {
            value = "\(data)"
        } else {
            value = isOptional ? nil : ""
        }

        return value
    }

    private func decodeNumber(
        container: KeyedDecodingContainer<BaseCodingKey>,
        key: BaseCodingKey
    ) -> NSNumber? {
        let value: NSNumber?

        if let data = try? container.decode(String.self, forKey: key) {
            value = NumberFormatter().number(from: data)
        } else if let data = try? container.decode(Int.self, forKey: key) {
            value = NSNumber(value: data)
        } else if let data = try? container.decode(Int64.self, forKey: key) {
            value = NSNumber(value: data)
        } else if let data = try? container.decode(Double.self, forKey: key) {
            value = NSNumber(value: data)
        } else if let data = try? container.decode(Bool.self, forKey: key) {
            value = NSNumber(value: data)
        } else {
            value = nil
        }

        return value
    }

    private func decodeValue<T: Decodable>(
        container: KeyedDecodingContainer<BaseCodingKey>,
        key: BaseCodingKey
    ) -> T? {
        try? container.decode(T.self, forKey: key)
    }

    func castToJsonDictionary() -> [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self) else { return [:] }
        guard let object = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return [:]
        }
        return object
    }
}

extension Decodable {
    static func create<T: Decodable>(JSON: [String: Any?], userInfo: [CodingUserInfoKey: Any] = [:]) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: JSON) else { return nil }

        let decoder = JSONDecoder()
        decoder.userInfo = userInfo

        return try? decoder.decode(T.self, from: jsonData)
    }

    static func create<T: Decodable>(JSONString: String?, userInfo: [CodingUserInfoKey: Any] = [:]) -> T? {
        guard let jsonData = JSONString?.data(using: .utf8) else { return nil }

        let decoder = JSONDecoder()
        decoder.userInfo = userInfo

        return try? decoder.decode(T.self, from: jsonData)
    }
}

extension KeyedDecodingContainer {
    func decode<T: Any>(_ type: [String: T].Type, forKey key: K) throws -> [String: T] {
        let container = try nestedContainer(keyedBy: BaseCodingKey.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent<T: Any>(_ type: [String: T].Type, forKey key: K) throws -> [String: T]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode<T: Any>(_ type: [T].Type, forKey key: K) throws -> [T] {
        var container = try nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent<T: Any>(_ type: [T].Type, forKey key: K) throws -> [T]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode<T: Any>(_: [String: T].Type) throws -> [String: T] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary as? [String: T] ?? [:]
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode<T: Any>(_: [T].Type) throws -> [T] {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `nil` first and prevent infinite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array as? [T] ?? []
    }

    mutating func decode<T: Any>(_ type: [String: T].Type) throws -> [String: T] {
        let nestedContainer = try self.nestedContainer(keyedBy: BaseCodingKey.self)
        return try nestedContainer.decode(type)
    }
}
