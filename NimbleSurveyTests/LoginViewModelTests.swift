//
//  LoginViewModelTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!

    override func setUp() {
        super.setUp()
        sut = LoginViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testValidation() {
        sut.email.accept("")
        expect(self.sut.validation()).to(beFalse())
        expect(self.sut.errorMsg.value) == "Please enter email"
        sut.email.accept("AA")
        expect(self.sut.validation()).to(beFalse())
    }
}
