//
//  BaseCodableResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RealmSwift

class BaseCodableResponseEntity: BaseCodable {
    let status = RealmOptional<Int>()
    let code = RealmOptional<Int>()
    @objc dynamic var message: String = ""
    @objc dynamic var apiInfo: APIInfoEntity?
    @objc dynamic var error: APIErrorEntity?

    override var manualKeys: [String] {
        [
            CodingKeysBaseCodableResponseEntity.status.rawValue,
            CodingKeysBaseCodableResponseEntity.code.rawValue,
            CodingKeysBaseCodableResponseEntity.apiInfo.rawValue,
            CodingKeysBaseCodableResponseEntity.error.rawValue
        ]
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysBaseCodableResponseEntity.self)

        status.value = try? values?.decodeIfPresent(Int.self, forKey: .status)
        code.value = try? values?.decodeIfPresent(Int.self, forKey: .code)
        apiInfo = try? values?.decodeIfPresent(APIInfoEntity.self, forKey: .apiInfo)
        error = try? values?.decodeIfPresent(APIErrorEntity.self, forKey: .error)
    }
    
    required init() {
        super.init()
    }
    
    private enum CodingKeysBaseCodableResponseEntity: String, CodingKey {
        case status, message, error, code, apiInfo
    }
}

extension BaseCodableResponseEntity: CustomNSError {
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: message]
    }
}

extension BaseCodableResponseEntity: @unchecked Sendable {}
