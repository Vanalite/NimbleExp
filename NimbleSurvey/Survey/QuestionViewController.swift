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
    lazy var freeTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func configureUI() {
        let currentQuestion = viewModel.getCurrentQuestion()
        switch currentQuestion.answerType {
        case .rating:
            constructRatingView(displayType: currentQuestion.displayType)
        case .freeText:
            constructFreeTextField(question: currentQuestion)
        default: // Missing other question types
            return
        }
        questionsCountLabel.text = viewModel.questionCountText()
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

    private func constructRatingView(displayType: SurveyDetailEntity.DisplayType) {
        ratingView.configure(ratingStyle: displayType)
        answerWrapperView.addSubview(ratingView)
        ratingView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.greaterThanOrEqualTo(56)
        }
    }

    private func constructFreeTextField(question: SurveyDetailEntity) {
        let wrapperView = UIView()
        answerWrapperView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        wrapperView.layer.cornerRadius = 12
        wrapperView.layer.masksToBounds = true
        wrapperView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        wrapperView.addSubview(freeTextField)
        freeTextField.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(168)
        }
        freeTextField.contentVerticalAlignment = .top
        freeTextField.contentHorizontalAlignment = .leading
        freeTextField.backgroundColor = .clear
        freeTextField.placeholder = question.answerPlaceholder
        freeTextField.placeHolderColor = UIColor(white: 1, alpha: 0.5)
        freeTextField.textColor = .white
    }
}
