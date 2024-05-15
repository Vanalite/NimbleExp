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
import Kingfisher

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
    let menuView = MenuView.instantiate(message: "")
    let slideInViewWidth: CGFloat = 240
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }

    private func fetchData() {
        viewModel.fetchSurvey().drive(onNext: { [weak self] surveys in
            self?.reconfigureUI(surveys)
        })
        .disposed(by: disposeBag)
        viewModel.fetchUser().drive(onNext: { [weak self] user in
            self?.assignUsername(user: user)
        })
        .disposed(by: disposeBag)
    }

    private func configureUI() {
        setCurrentTime()
        containerView.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(slideMenuOut))
        containerView.addGestureRecognizer(tapGesture)
        menuView.delegate = self
    }

    private func bindViewModel() {
        avatarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.slideMenuIn()
            })
            .disposed(by: disposeBag)

        startSurveyButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToSurveyEntrance()
            })
            .disposed(by: disposeBag)
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
        containerView.alpha = 0
        containerView.frame = self.view.frame
        containerView.addSubview(menuView)
        let screenSize = UIScreen.main.bounds.size
        window?.addSubview(containerView)
        menuView.frame = CGRect(x: screenSize.width, y: 0, width: slideInViewWidth, height: screenSize.height)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.containerView.alpha = 1
            self.menuView.frame = CGRect(x: screenSize.width - self.slideInViewWidth, y: 0, width: self.slideInViewWidth, height: screenSize.height)
        })
    }

    private func navigateToSurveyEntrance() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let surveyEntranceViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyEntranceViewController") as! SurveyEntranceViewController
        if let startingSurvey = viewModel.surveyList.first {
            let viewModel = SurveyEntranceViewModel(surveyData: startingSurvey)
            surveyEntranceViewController.viewModel = viewModel
        }
        navigationController?.pushViewController(surveyEntranceViewController, animated: true)
    }

    @objc private func slideMenuOut() {
        UIView.animate(withDuration: 0.5,
                       delay: 0, 
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, 
                       animations: { [weak self] in
            self?.containerView.alpha = 0
        }, completion: { [weak self] _ in
            self?.containerView.removeFromSuperview()
        })
    }

    private func reconfigureUI(_ surveys: SurveyResponseEntity) {
        guard let survey = surveys.data?.first?.attributes else { return }
        titleLabel.text = survey.title
        descriptionLabel.text = survey.descriptionString
        let url = URL(string: survey.coverImageUrl)
        bgImageView.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }

    private func assignUsername(user: UserEntity) {
        menuView.assignUsername(user.name)
    }
}

extension HomeViewController: MenuViewDelegate {
    func logoutDidTap(_ sender: Any) {
        containerView.removeFromSuperview()
        navigationController?.popToRootViewController(animated: true)
    }
}
