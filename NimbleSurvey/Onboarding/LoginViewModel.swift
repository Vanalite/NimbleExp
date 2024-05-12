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

final class LoginViewModel: ViewModelType {
    private var rxLoginItems: Observable<(Array<UserEntity>, RealmChangeset?)> = Observable.empty()

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

    func transform(input: Input) -> Output {
        let handleLogin = input.loginButtonTap
            .withLatestFrom(Driver.combineLatest(input.emailText, input.passwordText))
            .throttle(.seconds(1), latest: false)
            .asObservable()
            .flatMap { [weak self] email, password -> Observable<LoginResponseEntity> in
                guard let self = self,
                      let email = email,
                      let password = password
                else { return .empty() }
                return self.netWorkService.loginRequest(email, password: password)
                    .asObservable()
            }
            .do { [weak self] user in
                guard let self = self else { return }
                try self.realm.write {
                    self.realm.add(user)
                }
            }
            .asDriver(onErrorJustReturn: LoginResponseEntity())
        return Output(reloadData: Driver<Void>.just(()),
                      items: handleLogin)
    }
}


extension LoginViewModel {
    struct Input {
        let emailText: Driver<String?>
        let passwordText: Driver<String?>
        let loginButtonTap: Driver<Void>
    }

    struct Output {
        let reloadData: Driver<Void>
        let items: Driver<LoginResponseEntity>
    }
}
