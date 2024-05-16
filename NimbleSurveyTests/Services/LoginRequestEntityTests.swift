//
//  LoginRequestEntityTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
@testable import NimbleSurvey

final class LoginRequestEntityTests: XCTestCase {
    var sut: LoginRequestEntity!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = LoginRequestEntity()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testEncoding() {
        sut.email = "email"
        sut.password = "emailpassword"
        let encoder = JSONEncoder()
        let data = try! encoder.encode(sut)
        let json: Dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

        expect(json["email"] as? String) == "email"
        expect(json["password"] as? String) == "emailpassword"
        expect(json["grant_type"] as? String) == "password"
        expect((json["client_id"] as? String)?.isEmpty).to(beFalse())
        expect((json["client_secret"] as? String)?.isEmpty).to(beFalse())
    }
}
