//
//  RatingView.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/15/24.
//

import Foundation
import UIKit
import SnapKit

protocol RatingViewDelegate: AnyObject {
    func ratingDidSelect(_ sender: Any)
}

class RatingView: UIView {
    weak var delegate: RatingViewDelegate?
    @IBOutlet weak var ratingStackView: UIStackView!

    var ratingButtons: [UIButton] = []
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    static func instantiate(message: String) -> RatingView {
        let view: RatingView = initFromNib()
        return view
    }

    func configure(ratingStyle: SurveyDetailEntity.DisplayType, maxRate: Int = 5) {
        for i in 0..<maxRate {
            let button = UIButton()
            if ratingStyle.nonFaceStyle {
                button.titleLabel?.text = ratingStyle.displayValue
            } else {
                button.titleLabel?.text = SurveyDetailEntity.DisplayType.face(order: i).displayValue
            }
            ratingStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(36)
            }
            button.addTarget(self, action: #selector(ratingDidTap(_:)), for: .touchUpInside)
            button.tag = i
            button.alpha = 0.5
        }
        ratingStackView.spacing = 12
    }

    @objc
    func ratingDidTap(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        for i in 0...button.tag {
            if let highlightingButton = ratingStackView.viewWithTag(i) {
                highlightingButton.alpha = 1
            }
        }
    }
}
