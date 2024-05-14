//
//  SurveyRequestEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation

class SurveyRequestEntity: BaseCodable {
    @objc dynamic var pageNumber = 1
    @objc dynamic var pageSize = 3

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeysSurveyRequestEntity.self)
        try container.encodeIfPresent(pageNumber, forKey: .pageNumber)
        try container.encodeIfPresent(pageSize, forKey: .pageSize)
    }

    private enum CodingKeysSurveyRequestEntity: String, CodingKey {
        case pageNumber = "page[number]"
        case pageSize = "page[size]"
    }
}
