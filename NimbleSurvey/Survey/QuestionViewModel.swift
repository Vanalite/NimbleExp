//
//  QuestionViewModel.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/15/24.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

class QuestionViewModel {
    var surveyDetailList: [SurveyDetailEntity] = []
    var surveyData: SurveyDataEntity
    private let netWorkService : NetworkService
    private let disposeBag = DisposeBag()

    init(surveyData: SurveyDataEntity,
         netWorkService: NetworkService = NetworkService()) {
        self.surveyData = surveyData
        self.netWorkService = netWorkService
    }


    func fetchUser() -> Driver<UserEntity> {
        return self.netWorkService.getUser()
            .asObservable()
            .asDriverOnErrorJustComplete()
    }

}
