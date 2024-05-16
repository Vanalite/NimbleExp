//
//  SurveyRequestEntityTest.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class SurveyRequestEntityTest: XCTestCase {
    var sut: SurveyRequestEntity!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = SurveyRequestEntity()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testEncoding() {
        sut.pageNumber = 2
        sut.pageSize = 5
        let encoder = JSONEncoder()
        let data = try! encoder.encode(sut)
        let json: Dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

        expect(json["page[number]"] as? Int) == 2
        expect(json["page[size]"] as? Int) == 5
    }
}
