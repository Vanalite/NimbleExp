//
//  SubmitResponsesRequestEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/15/24.
//

import Foundation

class SubmitResponsesRequestEntity: BaseCodable {
    var surveyId: String = ""
    var questions: [QuestionRequestEntity] = []

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeysSubmitResponsesRequestEntity.self)
        try container.encodeIfPresent(surveyId, forKey: .surveyId)
        try container.encodeIfPresent(questions, forKey: .questions)
    }

    private enum CodingKeysSubmitResponsesRequestEntity: String, CodingKey {
        case surveyId = "survey_id"
        case questions
    }
}

class QuestionRequestEntity: BaseCodable {
    var questionId: String = ""
    var answers: [AnswerRequestEntity] = []

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeysQuestionRequestEntity.self)
        try container.encodeIfPresent(questionId, forKey: .questionId)
        try container.encodeIfPresent(answers, forKey: .answers)
    }

    private enum CodingKeysQuestionRequestEntity: String, CodingKey {
        case questionId = "id"
        case answers
    }
}

class AnswerRequestEntity: BaseCodable {
    var answerId: String = ""
    var answer: String = ""

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeysAnswerRequestEntity.self)
        try container.encodeIfPresent(answerId, forKey: .answerId)
        try container.encodeIfPresent(answer, forKey: .answer)
    }

    private enum CodingKeysAnswerRequestEntity: String, CodingKey {
        case answerId = "id"
        case answer
    }
}
