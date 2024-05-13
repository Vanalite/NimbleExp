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
    case login(request: LoginRequestEntity)

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
        }
    }

    var path: String {
        switch self {
        case .login:
            return NetworkAPI.kLogin
        }
    }

    var isLogable: Bool {
        return true
    }

    var task: Task {
        switch self {
        case .login(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }
}
