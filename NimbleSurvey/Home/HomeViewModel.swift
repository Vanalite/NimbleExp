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

    var user: UserEntity?
    var surveyList: [SurveyDataEntity] = []
    var currentSurveyIndex = 0

    private let netWorkService : NetworkService
    private let realm: Realm
    private let disposeBag = DisposeBag()

    init(
        netWorkService: NetworkService = NetworkService(),
        realm: Realm = RealmManager.shared.mainThreadRealm
    ) {
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
            .do(onNext: { [weak self] newUser in
                self?.user = newUser
            })
            .asDriverOnErrorJustComplete()
    }
}
