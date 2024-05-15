//
//  SurveyDetailResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation

class SurveyDetailResponseEntity: BaseCodableResponseEntity {

    var surveyId: String = ""
    var questions: [SurveyDetailEntity] = []

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyDetailResponseEntity.self)

        if let data = try? values?.nestedContainer(keyedBy: CodingKeysSurveyDetailResponseEntity.self, forKey: .data) {
            if let surveyId = try? data.decodeIfPresent(String.self, forKey: .surveyId) {
                self.surveyId = surveyId
            }
        }

        if let array = try? values?.decodeIfPresent([SurveyDetailEntity].self, forKey: .included) {
            questions = array
        }
    }

    private enum CodingKeysSurveyDetailResponseEntity: String, CodingKey {
        case data
        case surveyId = "id"
        case included
        case attributes
    }
}

class SurveyDetailEntity: BaseCodable {
    var text: String = ""
    var answerPlaceholder: String = "Your thought"
    var _type: String = QuestionType.answer.rawValue
    var _displayType: String = DisplayType.star.displayValue
    var _answerType: String = AnswerType.rating.rawValue

    var type: QuestionType {
        return QuestionType(rawValue: _type) ?? .answer
    }

    var displayType: DisplayType {
        return DisplayType.mapValue(rawValue: _displayType)
    }

    var answerType: AnswerType {
        return AnswerType(rawValue: _answerType) ?? .rating
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
                if displayType == "default" {
                    self._answerType = AnswerType.freeText.rawValue
                    if let answerPlaceholder = try? data.decodeIfPresent(String.self, forKey: .inputMaskPlaceholder) {
                        self.answerPlaceholder = answerPlaceholder
                    }
                } else if AnswerType.isRatingType(displayType: displayType) {
                    self._answerType = AnswerType.rating.rawValue
                }
                self._displayType = displayType
            }
        }

    }

    private enum CodingKeysSurveyDetailEntity: String, CodingKey {
        case type
        case attributes
        case text
        case displayType = "display_type"
        case inputMaskPlaceholder = "input_mask_placeholder"
    }

}

extension SurveyDetailEntity {
    enum QuestionType: String {
        case answer
        case question
    }

    enum DisplayType: Equatable {
        case star
        case thumb
        case heart
        case face(order: Int)

        var displayValue: String {
            switch self {
            case .star: return "⭐️️"
            case .thumb: return "👍🏻"
            case .heart: return "❤️"
            case .face(let order): do {
                switch order {
                case 0: return "😡"
                case 1: return "😕"
                case 2: return "😐"
                case 3: return "🙂"
                case 4: return "😄"
                default: return ""
                }
            }}
        }

        var jsonValue: String {
            switch self {
            case .star: return "star"
            case .thumb: return "thumb"
            case .heart: return "heart"
            case .face: return "face"
            }
        }

        var nonFaceStyle: Bool {
            return [.star, .thumb, .heart].contains(where: { $0 == self})
        }

        static func mapValue(rawValue: String) -> Self {
            switch rawValue {
            case "star": return .star
            case "thumb": return .thumb
            case "heart": return .heart
            case "face": return .face(order: 0)
            default: return .star
            }
        }
    }

    enum AnswerType: String {
        case rating
        case freeText
        case multipleChoice
        case yesNo
        case nps
        case field

        static func isRatingType(displayType: String) -> Bool {
            return ["star", "thumb", "heart", "face"].contains(displayType)
        }
    }
}
