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

    private let netWorkService : NetworkService
    private let realm: Realm
    private let disposeBag = DisposeBag()

    init(netWorkService: NetworkService = NetworkService(),
         realm: Realm = RealmManager.shared.mainThreadRealm) {
        self.netWorkService = netWorkService
        self.realm = realm
    }

    func fetchSurvey() -> Driver<SurveyResponseEntity> {
        return self.netWorkService.fetchSurvey()
            .asDriver(onErrorJustReturn: SurveyResponseEntity())
    }
}
