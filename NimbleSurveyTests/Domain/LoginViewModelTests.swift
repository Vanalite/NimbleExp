//
//  LoginViewModelTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
import Cuckoo
import RxSwift
import RxTest
import RxCocoa
@testable import NimbleSurvey

final class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    var networkService: NetworkServiceMock!
    var testScheduler: TestScheduler!
    var disposeBag = DisposeBag()

    let stubGetLoginResponseFileName = "login"

    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        networkService = NetworkServiceMock()
        sut = LoginViewModel(netWorkService: networkService)
    }

    override func tearDown() {
        networkService = nil
        sut = nil
        super.tearDown()
    }

    func testValidation() {
        sut.email.accept("")
        expect(self.sut.validation()).to(beFalse())
        expect(self.sut.errorMsg.value) == "Please enter email"
        sut.email.accept("AA")
        expect(self.sut.validation()).to(beFalse())
        expect(self.sut.errorMsg.value) == "Please enter valid email"
        sut.email.accept("example@email.com")
        expect(self.sut.validation()).to(beFalse())
        expect(self.sut.errorMsg.value) == "Please enter password"
        sut.password.accept("password")
        expect(self.sut.validation()).to(beTrue())
    }

    func testHandleLogin() {
        let testObserver: TestableObserver<LoginResponseEntity> = testScheduler.createObserver(LoginResponseEntity.self)
        sut.handleLogin()
            .drive(testObserver)
            .disposed(by: disposeBag)

        expect(testObserver.events).to(equal([
            .next(0, networkService.loginResponseEntity),
            .completed(0)
        ]))
    }
}
