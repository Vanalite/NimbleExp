//
//  NetworkServiceMock.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import Foundation
import RxSwift
import RxCocoa
@testable import NimbleSurvey

class NetworkServiceMock: NetworkService {
    let loginResponseEntity = LoginResponseEntity()
    override func loginRequest(_ email: String, password: String) -> Single<LoginResponseEntity> {
        return Single<LoginResponseEntity>.create { single -> Disposable in
            single(.success(self.loginResponseEntity))
            return Disposables.create()
        }
    }

    let userEntity = UserEntity()
    override func getUser() -> Single<UserEntity> {
        return Single<UserEntity>.create { single -> Disposable in
            single(.success(self.userEntity))
            return Disposables.create()
        }
    }

    let surveyEntity = SurveyResponseEntity()
    override func fetchSurvey(pageNumber: Int = 1, pageSize: Int = 5) -> Single<SurveyResponseEntity> {
        return Single<SurveyResponseEntity>.create { single -> Disposable in
            single(.success(self.surveyEntity))
            return Disposables.create()
        }
    }

}
