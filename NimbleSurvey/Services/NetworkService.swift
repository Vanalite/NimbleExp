//
//  NetworkService.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Moya
import RxSwift
import SwiftyJSON

class NetworkService: NSObject {
    var apiProvider: APIProvider

    enum RetryableConfig {
        static let maxRetryAttempts: Int = 1
        static let attemptNumberToNotRetry: Int = 0
    }

    init(apiProvider: APIProvider = APIProvider.shared) {
        self.apiProvider = apiProvider
    }

    func loginRequest(_ email: String, password: String) -> Single<LoginResponseEntity> {
        let request = LoginRequestEntity()
        request.email = email
        request.password = password
        return requestObject(endpoint: .login(request: request), ignoreUnauthorized: true)
    }

    func fetchSurvey(pageNumber: Int = 1, pageSize: Int = 5) -> Single<SurveyResponseEntity> {
        let request = SurveyRequestEntity()
        request.pageSize = pageSize
        request.pageNumber = pageNumber
        return requestObject(endpoint: .fetchSurvey(request: request))
    }

    func request(
        endpoint: NetworkAPI,
        ignoreUnauthorized: Bool = false,
        maxRetryAttempts: Int = RetryableConfig.maxRetryAttempts
    ) -> Single<Response> {
        return apiProvider
            .provider
            .rx
            .request(endpoint, callbackQueue: DispatchQueue.global(qos: .utility))
            .filterSuccessfulStatusCodes()
            .mapApiMoyaError()
            .retry(maxRetryAttempts)
    }

    func requestObject<T: Decodable>(
        endpoint: NetworkAPI,
        userInfo: [CodingUserInfoKey: Any] = [:],
        ignoreUnauthorized: Bool = false,
        maxRetryAttempts: Int = RetryableConfig.maxRetryAttempts
    ) -> Single<T> {
        request(
            endpoint: endpoint,
            ignoreUnauthorized: ignoreUnauthorized,
            maxRetryAttempts: maxRetryAttempts
        )
        .mapObject(T.self, userInfo: userInfo)
    }

    func requestObjectOnMainThread<T: Decodable>(
        endpoint: NetworkAPI,
        userInfo: [CodingUserInfoKey: Any] = [:],
        ignoreUnauthorized: Bool = false,
        maxRetryAttempts: Int = RetryableConfig.maxRetryAttempts
    ) -> Single<T> {
        requestObject(
            endpoint: endpoint,
            userInfo: userInfo,
            ignoreUnauthorized: ignoreUnauthorized,
            maxRetryAttempts: maxRetryAttempts
        )
        .observe(on: MainScheduler.instance)
    }

    func requestAndMapToJSON(endpoint: NetworkAPI, ignoreUnauthorized: Bool = false) -> Single<[String: Any]> {

        return request(endpoint: endpoint, ignoreUnauthorized: ignoreUnauthorized)
            .map { try ($0.mapJSON() as? [String: Any]) ?? [:] }
    }

    func requestDecodable<T: Decodable>(
        endpoint: NetworkAPI,
        decoder: JSONDecoder = .init(),
        maxRetryAttempts: Int = RetryableConfig.maxRetryAttempts
    ) -> Single<T> {
        return apiProvider
            .provider
            .rx
            .request(endpoint, callbackQueue: DispatchQueue.global(qos: .utility))
            .filterSuccessfulStatusCodes()
            .retry(maxRetryAttempts)
            .map { try decoder.decode(T.self, from: $0.data) }
    }
}

