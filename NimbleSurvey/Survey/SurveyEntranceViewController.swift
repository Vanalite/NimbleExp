//
//  SurveyEntranceViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class SurveyEntranceViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    var viewModel: SurveyEntranceViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let attributes = viewModel.surveyData.attributes else { return }
        populateData(
            title: attributes.title,
            description: attributes.descriptionString,
            bgImageURLString: attributes.coverImageUrl
        )
    }

    func populateData(title: String, description: String, bgImageURLString: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        if let urlString = bgImageURLString, let url = URL(string: urlString) {
            bgImageView.kf.setImage(with: url) // Resever for loading image on low network
        }
    }

    private func bindViewModel() {
        backButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        startButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.getSurveyDetails()
                    .drive(onNext: { [weak self] response in
                        self?.navigateToSurveyDetail(response)
                    }, onCompleted: nil)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    private func navigateToSurveyDetail(_ surveyDetailResponse: SurveyDetailResponseEntity) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        let viewModel = QuestionViewModel(surveyDetailResponse: surveyDetailResponse)
        questionViewController.viewModel = viewModel
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}
