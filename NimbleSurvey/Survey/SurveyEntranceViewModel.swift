//
//  SurveyEntranceViewModel.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SurveyEntranceViewModel {
    var surveyData: SurveyDataEntity
    private let netWorkService : NetworkService
    private let disposeBag = DisposeBag()

    init(
        surveyData: SurveyDataEntity,
        netWorkService: NetworkService = NetworkService()
    ) {
        self.surveyData = surveyData
        self.netWorkService = netWorkService
    }

    func getSurveyDetails() -> Driver<SurveyDetailResponseEntity> {
        return netWorkService.getSurveyDetail(surveyId: surveyData.surveyId)
            .asObservable()
            .asDriverOnErrorJustComplete()
    }
}
