//
//  LoginRequestEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

class LoginRequestEntity: BaseCodable {
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    @objc dynamic var grantType = "password"
    @objc dynamic var clientId = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    @objc dynamic var clientSecret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"

    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeysLoginRequestEntity.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(grantType, forKey: .grantType)
        try container.encodeIfPresent(clientId, forKey: .clientId)
        try container.encodeIfPresent(clientSecret , forKey: .clientSecret)
    }

    private enum CodingKeysLoginRequestEntity: String, CodingKey {
        case email
        case password
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }

}
