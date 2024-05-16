//
//  SurveyResponseEntityTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class SurveyResponseEntityTests: XCTestCase {
    var sut: SurveyResponseEntity!
    let stubFetchSurveyResponseFileName = "fetch_survey"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = MockJSONAdapter.createMockModel(
            fromData: stubFetchSurveyResponseFileName,
            forType: SurveyResponseEntity.self
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testPurchaseOrderResponseEntityProperties() {
        expect(self.sut.data?.count) == 1
        guard let surveyData = sut.data?.first else {
            XCTFail("Cannot extract first survey")
            return
        }
        expect(surveyData.surveyId) == "d5de6a8f8f5f1cfe51bc"
        expect(surveyData.type) == "survey_simple"
        expect(surveyData.attributes?.title) == "Scarlett Bangkok"
        expect(surveyData.attributes?.descriptionString) == "We'd love ot hear from you!"
        expect(surveyData.attributes?.isActive).to(beTrue())
        expect(surveyData.attributes?.coverImageUrl) == "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_"
        expect(surveyData.attributes?.createdAt) == "2017-01-23T07:48:12.991Z"
        expect(surveyData.attributes?.activeAt) == "2015-10-08T07:04:00.000Z"
        expect(surveyData.attributes?.inactiveAt) == ""
        expect(surveyData.attributes?.surveyType) == "Restaurant"
    }
}
