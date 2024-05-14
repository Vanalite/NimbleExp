//
//  RequestPlugin.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/14/24.
//

import Foundation
import Moya
import RealmSwift

class RequestPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        prepareHTTPHeaders(of: request, target: target)
    }

    func prepareHTTPHeaders(of request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        let token = "Bearer \(APIProvider.shared.authenticationToken)"
        if let api = target as? NetworkAPI {
            switch api {
            case .login:
                break
            default:
                request.setValue(token, forHTTPHeaderField: Constants.AuthenticationHeader)
            }
        }

        return request
    }
}
