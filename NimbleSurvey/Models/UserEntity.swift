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
        if let data = try? values?.nestedContainer(keyedBy: CodingKeysUserEntity.self, forKey: .data) {
            if let attribute = try? data.nestedContainer(keyedBy: CodingKeysUserEntity.self, forKey: .attributes) {
                if let email = try? attribute.decodeIfPresent(String.self, forKey: .email) {
                    self.email = email
                }

                if let name = try? attribute.decodeIfPresent(String.self, forKey: .name) {
                    self.name = name
                }

                if let avatarUrl = try? attribute.decodeIfPresent(String.self, forKey: .avatarURL) {
                    self.avatarURL = avatarUrl
                }
            }
        }
    }

    private enum CodingKeysUserEntity: String, CodingKey {
        case data
        case attributes
        case email = "email"
        case name = "name"
        case avatarURL = "avatar_url"
    }
}
