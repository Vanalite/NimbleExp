//
//  MockJSONAdapter.swift
//  NimbleSurveyTests
//
//  Created by Vanalite on 5/16/24.
//

import XCTest
@testable import NimbleSurvey

extension Bundle {
    static var test: Bundle {
        Bundle(identifier: "vanalite.NimbleSurveyTests")!
    }
}

class MockJSONAdapter {
    static func createMockModel<T>(
        fromData dataFile: String,
        forType _: T.Type,
        userInfo: [CodingUserInfoKey: Any] = [:], bundle: Bundle = Bundle.test
    ) -> T where T: BaseCodable {
        guard let data = MockJSONAdapter.stubbedResponse(dataFile, bundle: bundle) else { return T() }

        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.userInfo = userInfo
            let realmObject = try jsonDecoder.decode(T.self, from: data)
            return realmObject
        } catch {
            XCTFail("Cannot get stub json")
            return T()
        }
    }

    static func stubbedResponse(_ filename: String, bundle: Bundle = Bundle.main, ofType: String = "json") -> Data! {
        let path = bundle.path(forResource: filename, ofType: ofType)
        return try? Data(contentsOf: URL(fileURLWithPath: path!))
    }
}
