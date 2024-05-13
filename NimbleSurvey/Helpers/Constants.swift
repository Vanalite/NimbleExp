//
//  Constants.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

enum Constants {
    static let baseURLPath = "https://nimble-survey-web-mock.fly.dev"
    static let authenticationToken = "Basic xxx"
    static let AppID = "60c6fbeb4b93ac653c492ba806fc346d"

    static let noNetworkErrorMessage = "No internet connection"
}

enum HTTPCode {
    static let unAuthorized = 403
    static let minSuccess = 200
    static let maxSuccess = 300
    static let notFound = 404
    static let internalServerError = 502
}

