//
//  MenuView.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation
import UIKit
import Kingfisher

protocol MenuViewDelegate: AnyObject {
    func logoutDidTap(_ sender: Any)
}

class MenuView: UIView {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    weak var delegate: MenuViewDelegate?

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

    func assignUsername(_ userName: String) {
        usernameLabel.text = userName
    }

    func assignUserAvatar(_ avatarURL: String) {
        guard let url = URL(string: avatarURL) else { return }
        avatarButton.kf.setImage(with: url, for: .normal)
    }

    @IBAction func logoutDidTap(_ sender: Any) {
        delegate?.logoutDidTap(sender)
    }
}
