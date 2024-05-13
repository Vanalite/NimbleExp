//
//  HomeViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation
import UIKit
import RxCocoa

class HomeViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var slideInView = UITableView()
    let slideInViewWidth: CGFloat = 240

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        bindViewModel()

    }

    private func configureUI() {
        setCurrentTime()
    }

    private func bindViewModel() {
        
    }

    private func setCurrentTime() {
        let currentDateTime = Date().formatted(
            Date.FormatStyle().weekday(.abbreviated).month().day()
        )
        dateLabel.text = currentDateTime // Mon, Feb 9
    }
}
