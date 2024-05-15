//
//  QuestionViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var answerWrapperView: UIView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel: QuestionViewModel!
    let ratingView = RatingView.instantiate(message: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ratingView.layoutSubviews()
    }

    private func configureUI() {
        answerWrapperView.addSubview(ratingView)
        ratingView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
        }
        ratingView.configure(ratingStyle: .star)
        questionsCountLabel.text = viewModel.questionCountText()
        let currentQuestion = viewModel.getCurrentQuestion()
        questionLabel.text = currentQuestion.text
    }

    private func bindViewModel() {
        closeButton.rx.tap.asDriver().drive(onNext:  { [weak self] in
            guard let self = self,
                  let navigationController = self.navigationController else { return }
            let homeViewController = navigationController.viewControllers.first {
                $0.isKind(of: HomeViewController.self)
            }
            if let homeViewController = homeViewController {
                navigationController.popToViewController(homeViewController, animated: true)
            }
        })
        .disposed(by: disposeBag)

        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            if viewModel.isLastQuestion() {
                self.navigateToThank()
            } else {
                self.moveToNextQuestion()
            }
        })
        .disposed(by: disposeBag)
    }

    private func navigateToThank() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let thankViewController = storyBoard.instantiateViewController(withIdentifier: "ThankViewController")
        navigationController?.pushViewController(thankViewController, animated: true)
    }

    private func moveToNextQuestion() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        let nextViewModel = QuestionViewModel(surveyDetailResponse: viewModel.surveyDetailResponse)
        nextViewModel.currentQuestionIndex = viewModel.currentQuestionIndex + 1
        questionViewController.viewModel = nextViewModel
        navigationController?.pushViewController(questionViewController, animated: true)

    }
}
