//
//  ViewModelType.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
