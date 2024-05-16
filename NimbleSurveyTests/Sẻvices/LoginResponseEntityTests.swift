//
//  LoginResponseEntityTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class LoginResponseEntityTests: XCTestCase {
    var sut: LoginResponseEntity!
    let stubGetLoginResponseFileName = "login"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = LoginResponseEntity()
        sut = MockJSONAdapter.createMockModel(
            fromData: stubGetLoginResponseFileName,
            forType: LoginResponseEntity.self
        )

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testPurchaseOrderResponseEntityProperties() {
        expect(self.sut.data).toNot(beNil())
        expect(self.sut.data?.identifier) == "123"
        expect(self.sut.data?.type) == "token"
        expect(self.sut.data?.attributes).toNot(beNil())
        expect(self.sut.data?.attributes?.accessToken) == "123-f2i0CG6MDsf-wJE9FyYrhSGAOtxBkhYWDI"
        expect(self.sut.data?.attributes?.tokenType) == "Bearer"
        expect(self.sut.data?.attributes?.expiresIn) == 7200
        expect(self.sut.data?.attributes?.refreshToken) == "l27GNT0kmkPbnEaUxniXyu4cHfPyWFr00kZTX5oWKA6c"
        expect(self.sut.data?.attributes?.createdAt) == 1681974651
    }
}
