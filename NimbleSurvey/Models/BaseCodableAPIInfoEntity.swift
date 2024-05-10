//
//  BaseCodableAPIInfoEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

enum APISessionErrorType: String {
    case concurentSession = "CONCURRENT_SESSION"
    case blockedSession = "BLOCKED_SESSION"
    case expiredSession = "EXPIRED_SESSION"
    case revokedSession = "REVOKED_SESSION"
}

class APIInfoEntity: BaseCodable {
    @objc dynamic var version: String?
    @objc dynamic var name: String?
    @objc dynamic var startTime: String?
}

class APIErrorEntity: BaseCodable {
    @objc dynamic var type: String?
    @objc dynamic var details: APIErrorDetail?
    override var manualKeys: [String] {
        [CodingKeysAPIErrorEntity.details.rawValue]
    }

    var sessionErrorType: APISessionErrorType {
        APISessionErrorType(rawValue: type ?? "") ?? .revokedSession
    }

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysAPIErrorEntity.self)
        details = try? values?.decodeIfPresent(APIErrorDetail.self, forKey: .details)
    }

    private enum CodingKeysAPIErrorEntity: String, CodingKey {
        case details
    }
}

class APIErrorDetail: BaseCodable {
    @objc dynamic var timeout: String?
    @objc dynamic var device: String?

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysAPIErrorDetail.self)

        timeout = try? values?.decodeIfPresent(String.self, forKey: .timeout)
        device = try? values?.decodeIfPresent(String.self, forKey: .device)
    }

    private enum CodingKeysAPIErrorDetail: String, CodingKey {
        case timeout = "params.timeout"
        case device = "params.device"
    }
}


class CustomError: CustomNSError, Equatable {
    let message: String

    init(message: String) {
        self.message = message
    }

    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: message]
    }

    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        lhs.message == rhs.message
    }
}

extension CustomError {
    static let referenceNoLongerExist: CustomError = .init(message: "Reference No Longer Exist")
    static let invalidData: CustomError = .init(message: "Invalid Data")
    static let unAuthorized: CustomError = .init(message: "Un-Authorized")
}
