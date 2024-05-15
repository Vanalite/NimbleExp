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
    var surveyDetailResponse: SurveyDetailResponseEntity
    private let netWorkService : NetworkService
    private let disposeBag = DisposeBag()

    init(surveyDetailResponse: SurveyDetailResponseEntity,
         netWorkService: NetworkService = NetworkService()) {
        self.surveyDetailResponse = surveyDetailResponse
        self.surveyDetailList = self.surveyDetailResponse.questions
        self.netWorkService = netWorkService
    }

    func fetchUser() -> Driver<UserEntity> {
        return self.netWorkService.getUser()
            .asObservable()
            .asDriverOnErrorJustComplete()
    }

}
