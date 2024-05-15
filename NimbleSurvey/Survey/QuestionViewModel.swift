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
    var currentQuestionIndex = 0
    private let netWorkService : NetworkService
    private let disposeBag = DisposeBag()

    var questionCount: Int {
        return surveyDetailList.count
    }

    init(surveyDetailResponse: SurveyDetailResponseEntity,
         netWorkService: NetworkService = NetworkService()) {
        self.surveyDetailResponse = surveyDetailResponse
        self.surveyDetailList = self.surveyDetailResponse.questions
        self.netWorkService = netWorkService
    }

    func questionCountText() -> String {
        return "\(currentQuestionIndex+1)/\(questionCount)"
    }

    func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionCount - 1
    }

    func getCurrentQuestion() -> SurveyDetailEntity {
        return surveyDetailList[currentQuestionIndex]
    }

    func fetchUser() -> Driver<UserEntity> {
        return self.netWorkService.getUser()
            .asObservable()
            .asDriverOnErrorJustComplete()
    }

}
