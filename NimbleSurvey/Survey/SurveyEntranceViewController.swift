//
//  SurveyEntranceViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SurveyEntranceViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startSurveyButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let thankViewController = storyBoard.instantiateViewController(withIdentifier: "ThankViewController")
        navigationController?.pushViewController(thankViewController, animated: true)
    }
}
