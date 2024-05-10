//
//  BaseEncodable.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

protocol BaseEncodableProtocol: Encodable {
    var manualKeys: [String] { get }
}

class BaseEncodable: BaseEncodableProtocol {
    var manualKeys: [String] {
        []
    }

    func encode(to encoder: Encoder) throws {
//        try commonEncode(to: encoder)
    }
}

//extension BaseEncodableProtocol {
//    func commonEncode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: BaseCodingKey.self)
//
//        let reflection = Reflector.reflect(from: self, withAncestorsRequirements: .all)
//        let keys: [BaseCodingKey] = reflection.names.compactMap { BaseCodingKey(stringValue: $0) }
//
//        for key in keys {
//            let name = key.stringValue
//
//            guard !manualKeys.contains(name), let child = reflection.children(name), name != "dummyId" else {
//                continue
//            }
//
//            switch child.type.valueType {
//            case .string:
//                let value: String? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .array(of: .string):
//                let value: [String]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .dictionary(key: .string, value: .string):
//                let value: [String: String]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .bool:
//                let value: Bool? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .array(of: .bool):
//                let value: [Bool]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .dictionary(key: .string, value: .bool):
//                let value: [String: Bool]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .int:
//                let value: Int? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .array(of: .int):
//                let value: [Int]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .dictionary(key: .string, value: .int):
//                let value: [String: Int]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .int64:
//                let value: Int64? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .array(of: .int64):
//                let value: [Int64]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .dictionary(key: .string, value: .int64):
//                let value: [String: Int64]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .float:
//                let value: Float? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .double:
//                let value: Double? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .array(of: .double):
//                let value: [Double]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            case .dictionary(key: .string, value: .double):
//                let value: [String: Double]? = reflection.value(for: name)
//                try container.encodeIfPresent(value, forKey: key)
//            default:
//                break
//            }
//        }
//    }
//}

extension Encodable {
    func toJSONArray() -> [Any] {
        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(self)

            return try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any]) ?? []
        } catch {
            logger.error(error.localizedDescription)
        }

        return []
    }

    func toJSON() -> [String: Any] {
        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(self)

            return try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]) ?? [:]
        } catch {
            logger.error(error.localizedDescription)
        }

        return [:]
    }

    func toJSONString(prettyPrint: Bool = false) -> String? {
        let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
        if let JSON = toJSONData(toJSON(), options: options) {
            return String(data: JSON, encoding: .utf8)
        }

        return nil
    }

    func toJSONData(_ JSONObject: Any, options: JSONSerialization.WritingOptions) -> Data? {
        if JSONSerialization.isValidJSONObject(JSONObject) {
            let JSONData: Data?
            do {
                JSONData = try JSONSerialization.data(withJSONObject: JSONObject, options: options)
            } catch {
                logger.error(error)
                JSONData = nil
            }

            return JSONData
        }

        return nil
    }
}
