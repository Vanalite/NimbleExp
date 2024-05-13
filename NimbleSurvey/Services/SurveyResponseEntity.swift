//
//  SurveyResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation

class SurveyResponseEntity: BaseCodableResponseEntity {
    var data: LoginToken?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyResponseEntity.self)

        if let data = try? values?.decodeIfPresent(LoginToken.self, forKey: .data) {
            self.data = data
        }
    }

    required init() {
        super.init()
    }

    private enum CodingKeysSurveyResponseEntity: String, CodingKey {
        case data
    }
}
