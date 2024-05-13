//
//  MenuView.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation
import UIKit

class MenuView: UIView {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    static func instantiate(message: String) -> MenuView {
        let view: MenuView = initFromNib()
        view.logoutButton.contentHorizontalAlignment = .left
        return view
    }
}

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
