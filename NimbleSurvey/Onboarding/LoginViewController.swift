//
//  LoginViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import UIKit
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordWrapperView: UIView!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        title = "Nimble"
        bgImageView.image = bgImageView.image?.blurEffect(20)
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.masksToBounds = true
        passwordWrapperView.layer.cornerRadius = 12
        passwordWrapperView.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        setGradientBackground()
    }

    private func setGradientBackground() {
        let colorTop =  UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = overlayView.bounds

        overlayView.layer.insertSublayer(gradientLayer, at:0)
    }

    private func bindViewModel() {
        viewModel = LoginViewModel()
        let input = buildViewModelInput()
        let output = viewModel.transform(input: input)
    }
    
    private func buildViewModelInput() -> LoginViewModel.Input {
        return .init(emailText: emailTextField.rx.text.trimmed.asDriver(),
                     passwordText: passwordTextField.rx.text.trimmed.asDriver(),
                     loginButtonTap: loginButton.rx.tap.asDriver()
        )
    }
}

