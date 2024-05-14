//
//  ThankViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation
import UIKit

class ThankViewController: UIViewController {
    let displayDuration = 3
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoDismiss()
    }

    private func autoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            guard let navigationController = self.navigationController else { return }
            let homeViewController = navigationController.viewControllers.first {
                $0.isKind(of: HomeViewController.self)
            } 
            if let homeViewController = homeViewController {
                navigationController.popToViewController(homeViewController, animated: true)
            }
        })
    }
}
