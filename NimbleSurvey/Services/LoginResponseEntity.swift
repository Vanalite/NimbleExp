//
//  LoginResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

class LoginResponseEntity: BaseCodableResponseEntity {
    var data: LoginToken?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysLoginResponseEntity.self)

        if let data = try? values?.decodeIfPresent(LoginToken.self, forKey: .data) {
            self.data = data
        }
    }
    
    required init() {
        super.init()
    }
    
    private enum CodingKeysLoginResponseEntity: String, CodingKey {
        case data
    }

}

class LoginToken: BaseCodableResponseEntity {
    var identifier: String = ""
    var type: String = ""
    var attributes: LoginTokenAttribute?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysLoginToken.self)
        if let identifier = try? values?.decodeIfPresent(String.self, forKey: .identifier) {
            self.identifier = identifier
        }

        if let type = try? values?.decodeIfPresent(String.self, forKey: .type) {
            self.type = type
        }

        if let attributes = try? values?.decodeIfPresent(LoginTokenAttribute.self, forKey: .attributes) {
            self.attributes = attributes
        }
    }
    
    required init() {
        super.init()
    }
    
    private enum CodingKeysLoginToken: String, CodingKey {
        case identifier = "id"
        case type
        case attributes
    }

}

class LoginTokenAttribute: BaseCodableResponseEntity {
    var accessToken: String = ""
    var tokenType: String = ""
    var expiresIn: Int = 0
    var refreshToken: String = ""
    var createdAt: Double = 0
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try? decoder.container(keyedBy: CodingKeysLoginTokenAttribute.self)
        if let accessToken = try? values?.decodeIfPresent(String.self, forKey: .accessToken) {
            self.accessToken = accessToken
        }

        if let tokenType = try? values?.decodeIfPresent(String.self, forKey: .tokenType) {
            self.tokenType = tokenType
        }

        if let expiresIn = try? values?.decodeIfPresent(Int.self, forKey: .expiresIn) {
            self.expiresIn = expiresIn
        }

        if let refreshToken = try? values?.decodeIfPresent(String.self, forKey: .refreshToken) {
            self.refreshToken = refreshToken
        }

        if let createdAt = try? values?.decodeIfPresent(Double.self, forKey: .createdAt) {
            self.createdAt = createdAt
        }
    }

    private enum CodingKeysLoginTokenAttribute: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }

}
