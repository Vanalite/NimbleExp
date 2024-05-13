//
//  SurveyRequestEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation

class SurveyRequestEntity: BaseCodable {
    var pageNumber = 1
    var pageSize = 3

    private enum CodingKeysSurveyRequestEntity: String, CodingKey {
        case pageNumber = "page[number]"
        case pageSize = "page[size]"
    }
}
