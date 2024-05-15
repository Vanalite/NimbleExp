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

    let disposeBag = DisposeBag()
    var viewModel: QuestionViewModel!
    let ratingView = RatingView.instantiate(message: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        answerWrapperView.addSubview(ratingView)
        ratingView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
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
            self.navigateToThank()
        })
        .disposed(by: disposeBag)
    }

    private func navigateToThank() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let thankViewController = storyBoard.instantiateViewController(withIdentifier: "ThankViewController")
        navigationController?.pushViewController(thankViewController, animated: true)
    }
}
