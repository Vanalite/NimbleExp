//
//  SurveyDetailResponseEntityTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class SurveyDetailResponseEntityTests: XCTestCase {
    var sut: SurveyDetailResponseEntity!
    let stubFetchSurveyResponseFileName = "survey_detail"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = MockJSONAdapter.createMockModel(
            fromData: stubFetchSurveyResponseFileName,
            forType: SurveyDetailResponseEntity.self
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testPurchaseOrderResponseEntityProperties() {
        expect(self.sut.surveyId) == "d5de6a8f8f5f1cfe51bc"
        expect(self.sut.questions.count) == 2
        guard let firstQuestion = sut.questions.first else {
            XCTFail("Cannot extract first question")
            return
        }
        expect(firstQuestion.text) == "1"
        expect(firstQuestion.answerPlaceholder) == "Your thought"
        expect(firstQuestion._type) == "answer"
        expect(firstQuestion._displayType) == "default"
        expect(firstQuestion._answerType) == "freeText"

    }
}
