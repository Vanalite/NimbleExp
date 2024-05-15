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
    var surveyData: SurveyDataEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func populateData(title: String, description: String, bgImage: UIImage?) {
        titleLabel.text = title
        descriptionLabel.text = description
        bgImageView.image = bgImage // Resever for loading image on low network
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startSurveyButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        if let surveyData = surveyData {
            let viewModel = QuestionViewModel(surveyData: surveyData)
            questionViewController.viewModel = viewModel
        }
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}
