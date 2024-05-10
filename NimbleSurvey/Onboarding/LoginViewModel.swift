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
        let reload = self.netWorkService.loginRequest("email", password: "password")
            .catchAndReturn(LoginResponseEntity())
            .map { [weak self] in
                guard let self = self else { return LoginResponseEntity() }
                let user = $0
                try self.realm.write {
                    self.realm.add(user)
                }
                return user as! LoginResponseEntity
            }
            .asObservable()
        return Output(reloadData: Driver<Void>.just(()),
                      items: reload)
    }
}


extension LoginViewModel {
    struct Input {
    }

    struct Output {
        let reloadData: Driver<Void>
        let items: Observable<LoginResponseEntity>
    }
}
