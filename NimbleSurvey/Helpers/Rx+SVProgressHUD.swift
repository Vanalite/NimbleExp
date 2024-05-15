//
//  Rx+SVProgressHUD.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/15/24.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD

public extension Reactive where Base: SVProgressHUD {
    /// Bindable sink for `show()`, `hide()` methods.
    static var isAnimating: Binder<Bool> {
        Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
