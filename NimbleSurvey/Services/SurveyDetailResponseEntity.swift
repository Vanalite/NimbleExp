//
//  SurveyDetailResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation

class SurveyDetailResponseEntity: BaseCodableResponseEntity {

    var detail: SurveyDetailEntity?
    var questions: [SurveyDetailEntity] = []

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyDetailResponseEntity.self)

        if let array = try? values?.decodeIfPresent([SurveyDetailEntity].self, forKey: .included) {
            questions = array
        }
    }

    private enum CodingKeysSurveyDetailResponseEntity: String, CodingKey {
        case data
        case included
        case attributes
    }
}

class SurveyDetailEntity: BaseCodable {
    enum QuestionType: String {
        case answer
        case question
    }

    enum DisplayType: String {
        case star
        case thumb
        case heart
        case face
    }

    var text: String = ""
    var _type: String = QuestionType.answer.rawValue
    var _displayType: String = DisplayType.star.rawValue

    var type: QuestionType {
        return QuestionType(rawValue: _type) ?? .answer
    }

    var displayType: DisplayType {
        return DisplayType(rawValue: _displayType) ?? .star
    }

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyDetailEntity.self)
        if let type = try? values?.decodeIfPresent(String.self, forKey: .type) {
            self._type = type
        }

        if let data = try? values?.nestedContainer(keyedBy: CodingKeysSurveyDetailEntity.self, forKey: .attributes) {
            if let text = try? data.decodeIfPresent(String.self, forKey: .text) {
                self.text = text
            }

            if let displayType = try? data.decodeIfPresent(String.self, forKey: .displayType) {
                self._displayType = displayType
            }
        }

    }

    private enum CodingKeysSurveyDetailEntity: String, CodingKey {
        case type
        case attributes
        case text
        case displayType = "display_type"
    }

}
