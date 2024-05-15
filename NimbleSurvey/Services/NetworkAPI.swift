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
    static let kFetchSurvey = "/surveys"
    static let kUser = "/me"
    static let kGetSurveyDetail = "/surveys/%@"
    static let kSubmitResponses = "/responses"

    case login(request: LoginRequestEntity)
    case getUser(request: BaseCodable)
    case fetchSurvey(request: SurveyRequestEntity)
    case getSurveyDetail(request: BaseCodable, surveyId: String)
    case submitResponses(request: SubmitResponsesRequestEntity)

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
        case .login, .submitResponses:
            return .post
        case .fetchSurvey, .getUser, .getSurveyDetail:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return NetworkAPI.kLogin
        case .getUser:
            return NetworkAPI.kUser
        case .fetchSurvey:
            return NetworkAPI.kFetchSurvey
        case .getSurveyDetail(let request, let surveyId):
            return String(format: NetworkAPI.kGetSurveyDetail, surveyId)
        case .submitResponses(let request):
            return NetworkAPI.kSubmitResponses
        }
    }

    var isLogable: Bool {
        return true
    }

    var task: Task {
        switch self {
        case .login(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding.default)
        case .getUser:
            return .requestPlain
        case .fetchSurvey(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case .getSurveyDetail:
            return .requestPlain
        case .submitResponses(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding.default)
        }
    }
}
