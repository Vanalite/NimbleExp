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

class QuestionViewController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {

    }

    private func bindViewModel() {
        closeButton.rx.tap.asDriver().drive {
            guard let navigationController = self.navigationController else { return }
            let homeViewController = navigationController.viewControllers.first {
                $0.isKind(of: HomeViewController.self)
            }
            if let homeViewController = homeViewController {
                navigationController.popToViewController(homeViewController, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}
