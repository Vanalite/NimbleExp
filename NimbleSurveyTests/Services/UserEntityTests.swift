//
//  UserEntityTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class UserEntityTests: XCTestCase {
    var sut: UserEntity!
    let stubUserResponseFileName = "user"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = MockJSONAdapter.createMockModel(
            fromData: stubUserResponseFileName,
            forType: UserEntity.self
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testPurchaseOrderResponseEntityProperties() {
        expect(self.sut.email) == "dev@nimblehq.co"
        expect(self.sut.name) == "Team Nimble"
        expect(self.sut.avatarURL) == "https://secure.gravatar.com/avatar/6733d09432e89459dba795de8312ac2d"
    }
}
