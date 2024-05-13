//
//  LoginViewModel.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class LoginViewModel {
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var errorMsg = BehaviorRelay<String>(value: "")
    private let netWorkService : NetworkService
    private let realm: Realm

    private let disposeBag: DisposeBag

    init(netWorkService: NetworkService = NetworkService(),
         realm: Realm = RealmManager.shared.mainThreadRealm) {
        self.netWorkService = netWorkService
        self.realm = realm
        self.disposeBag = DisposeBag()
        print("realm path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
    }

    func validation() -> Bool {

        if email.value.isEmpty {
            errorMsg.accept("Please enter email")
            return false
        } else if !(validateEmail()) {
            errorMsg.accept("Please enter valid email")
            return false
        } else if password.value.isEmpty {
            errorMsg.accept("Please enter password")
            return false
        }

        return true
    }

    func validateEmail() -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email.value)
    }

    func handleLogin() -> Driver<LoginResponseEntity> {
        return self.netWorkService.loginRequest(email.value, password: password.value)
            .do { [weak self] user in
                guard let self = self else { return }
                try self.realm.write {
                    self.realm.add(user)
                }
            }
            .asDriver(onErrorJustReturn: LoginResponseEntity())
    }
}
