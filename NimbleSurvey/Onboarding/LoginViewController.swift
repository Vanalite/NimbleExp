//
//  LoginViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordWrapperView: UIView!

    var viewModel: LoginViewModel!
    var disposeBag = DisposeBag()

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

        emailTextField
            .rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)


        passwordTextField
            .rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)


        loginButton
            .rx.tap
            .do(onNext :{ [unowned self] in
                self.view.endEditing(true)
            })
            .subscribe(onNext: { [unowned self] in
                if self.viewModel.validation() {
                    self.viewModel.handleLogin()
                        .drive({ response in
                            print(response)
                        })
                } else {
                    self.showAlert(msg: self.viewModel.errorMsg.value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(msg : String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

