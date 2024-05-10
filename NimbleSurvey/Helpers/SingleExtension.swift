//
//  SingleExtension.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Moya
import RxSwift

public extension Single where Trait == SingleTrait, Element == Response {
    func dataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            logger.error(myJSONError)
        }
        return nil
    }

    private func shouldIgnoreUnauthorize(path: String) -> Bool {
        let ignores = ["gps", "location"]

        for ignoreKey in ignores where path.contains(ignoreKey) {
            return true
        }

        return false
    }

    func mapObject<T: Decodable>(_: T.Type, userInfo: [CodingUserInfoKey: Any] = [:]) -> Single<T> {
        flatMap { response -> Single<T> in
            let decoder = JSONDecoder()
            decoder.userInfo = userInfo
            do {
                let object = try decoder.decode(T.self, from: response.data)
                return Single.just(object)
            } catch {
                return Single.error(error)
            }
        }
    }

    func mapObject<T: Codable>(_: T.Type, userInfo: [CodingUserInfoKey: Any] = [:]) -> Single<T> {
        flatMap { response -> Single<T> in
            let decoder = JSONDecoder()
            decoder.userInfo = userInfo
            do {
                let object = try decoder.decode(T.self, from: response.data)
                return Single.just(object)
            } catch {
                return Single.error(error)
            }
        }
    }

    func mapApiError() -> Single<Element> {
        flatMap { response -> Single<Element> in
            let statusCode: Int
            let responseObject: BaseCodableResponseEntity
            do {
                responseObject = try response.map(BaseCodableResponseEntity.self)
                statusCode = responseObject.status.value ?? responseObject.code.value ?? response.statusCode
            } catch {
                statusCode = response.statusCode
                return Single.error(CustomError(message: "Endpoint response data is corrupted. Status code \(statusCode)"))
            }
            if statusCode >= HTTPCode.minSuccess && statusCode < HTTPCode.maxSuccess {
                return Single.just(response)
            } else {
                return Single.error(responseObject)
            }
        }
    }

    func mapApiMoyaError() -> Single<Element> {
        flatMap { response -> Single<Element> in
            let statusCode: Int
            do {
                let responseObject = try response.map(BaseCodableResponseEntity.self)
                statusCode = responseObject.status.value ?? responseObject.code.value ?? response.statusCode
            } catch {
                statusCode = response.statusCode
                return Single.error(CustomError(message: "Endpoint response data is corrupted. Status code \(statusCode)"))
            }
            if statusCode >= HTTPCode.minSuccess && statusCode < HTTPCode.maxSuccess {
                return Single.just(response)
            } else {
                throw MoyaError.statusCode(response)
            }
        }
    }
}
