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
    }
}

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
            var json = try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]) ?? [:]
            json.removeValue(forKey: "dummyId")
            return json
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
