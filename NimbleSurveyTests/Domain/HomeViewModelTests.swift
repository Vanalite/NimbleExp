//
//  HomeViewModelTests.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import Cuckoo
@testable import NimbleSurvey

final class HomeViewModelTests: XCTestCase {

    var sut: HomeViewModel!
    var networkService: NetworkServiceMock!
    var testScheduler: TestScheduler!
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        networkService = NetworkServiceMock()
        sut = HomeViewModel(netWorkService: networkService)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchUser() {
        let testObserver: TestableObserver<UserEntity> = testScheduler.createObserver(UserEntity.self)
        sut.fetchUser()
            .drive(testObserver)
            .disposed(by: disposeBag)

        expect(testObserver.events).to(equal([
            .next(0, networkService.userEntity),
            .completed(0)
        ]))
    }

    func testFetchSurvey() {
        let testObserver: TestableObserver<SurveyResponseEntity> = testScheduler.createObserver(SurveyResponseEntity.self)
        sut.fetchSurvey()
            .drive(testObserver)
            .disposed(by: disposeBag)

        expect(testObserver.events).to(equal([
            .next(0, networkService.surveyEntity),
            .completed(0)
        ]))
    }
}
