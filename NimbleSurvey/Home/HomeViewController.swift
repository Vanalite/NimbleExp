//
//  HomeViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var startSurveyButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!

    var viewModel: HomeViewModel!
    var containerView = UIView()
    var slideInView = MenuView()
    let slideInViewWidth: CGFloat = 240
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        setCurrentTime()
        containerView.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(slideMenuOut))
        containerView.addGestureRecognizer(tapGesture)
    }

    private func bindViewModel() {
        avatarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.slideMenuIn()
        }).disposed(by: disposeBag)

        startSurveyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigateToSurveyEntrance()
        }).disposed(by: disposeBag)

        viewModel = HomeViewModel()

        viewModel.fetchSurvey().drive { [weak self] surveys in

        }
    }

    private func setCurrentTime() {
        let currentDateTime = Date().formatted(
            Date.FormatStyle().weekday(.abbreviated).month().day()
        )
        dateLabel.text = currentDateTime // Mon, Feb 9
    }

    private func slideMenuIn() {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.frame = self.view.frame

        slideInView = MenuView.instantiate(message: "")
        slideInView.delegate = self

        window?.addSubview(containerView)

        let screenSize = UIScreen.main.bounds.size
        slideInView.frame = CGRect(x: screenSize.width - slideInViewWidth, y: 0, width: slideInViewWidth, height: screenSize.height)
        containerView.addSubview(slideInView)
    }

    private func navigateToSurveyEntrance() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let surveyEntranceViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyEntranceViewController")
        navigationController?.pushViewController(surveyEntranceViewController, animated: true)
    }

    @objc private func slideMenuOut() {
        containerView.removeFromSuperview()
    }
}

extension HomeViewController: MenuViewDelegate {
    func logoutDidTap(_ sender: Any) {
        containerView.removeFromSuperview()
        navigationController?.popToRootViewController(animated: true)
    }
}
