//
//  NetworkAPI.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Moya
import RxSwift


enum NetworkAPI: TargetType {
    static let kLogin = "/oauth/token"
    static let kFetchSurvey = "surveys"
    
    case login(request: LoginRequestEntity)
    case fetchSurvey(request: SurveyRequestEntity)

    var sampleData: Data {
        return Data()
    }


    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var baseURL: URL {
        return URL(string: Constants.baseURLPath)!
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .fetchSurvey:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return NetworkAPI.kLogin
        case .fetchSurvey:
            return NetworkAPI.kFetchSurvey
        }
    }

    var isLogable: Bool {
        return true
    }

    var task: Task {
        switch self {
        case .login(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding.default)
        case .fetchSurvey(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }
}
