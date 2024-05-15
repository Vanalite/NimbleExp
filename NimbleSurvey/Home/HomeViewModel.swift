//
//  HomeViewModel.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

class HomeViewModel {

    var user: LoginResponseEntity
    var surveyList: [SurveyDataEntity] = []
    private let netWorkService : NetworkService
    private let realm: Realm
    private let disposeBag = DisposeBag()

    init(user: LoginResponseEntity,
         netWorkService: NetworkService = NetworkService(),
         realm: Realm = RealmManager.shared.mainThreadRealm) {
        self.user = user
        self.netWorkService = netWorkService
        self.realm = realm
    }

    func fetchSurvey() -> Driver<SurveyResponseEntity> {
        return self.netWorkService.fetchSurvey(pageNumber: 1)
            .asObservable()
            .do(onNext: { [weak self] surveys in
                guard let self = self else { return }
                self.surveyList = surveys.data ?? []
            })
            .asDriverOnErrorJustComplete()
    }

    func fetchUser() -> Driver<UserEntity> {
        return self.netWorkService.getUser()
            .asObservable()
            .asDriverOnErrorJustComplete()
    }
}
