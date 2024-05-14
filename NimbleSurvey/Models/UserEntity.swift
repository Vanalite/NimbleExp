//
//  UserEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RealmSwift

class UserEntity: BaseCodableResponseEntity {
    var email: String = ""
    var name: String = ""
    var avatarURL: String = ""

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysUserEntity.self)
        if let email = try? values?.decode(String.self, forKey: .email) {
            self.email = email
        }

        if let name = try? values?.decode(String.self, forKey: .name) {
            self.name = name
        }

        if let avatarUrl = try? values?.decodeIfPresent(String.self, forKey: .avatarURL) {
            self.avatarURL = avatarUrl
        }
    }

    private enum CodingKeysUserEntity: String, CodingKey {
        case email = "data.attributes.email"
        case name = "data.attributes.name"
        case avatarURL = "data.attributes.avatar_url"
    }
}
