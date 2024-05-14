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
    static let kUser = "/me"

    case login(request: LoginRequestEntity)
    case fetchSurvey(request: SurveyRequestEntity)
    case getUser(request: BaseCodable)

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer F6oR17w8OOvkrjb9Hg1ba5g2B4WpKTEbMueEU-V2xuQ"
        ]
    }

    var baseURL: URL {
        return URL(string: Constants.baseURLPath)!
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .fetchSurvey, .getUser:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return NetworkAPI.kLogin
        case .fetchSurvey:
            return NetworkAPI.kFetchSurvey
        case .getUser:
            return NetworkAPI.kUser
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
        case .getUser(let request):
            return .requestPlain
        }
    }
}
