//
//  Rx+String.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/12/24.
//

import Foundation
import RxCocoa
import RxSwift

extension ControlPropertyType where Element == String? {
    var trimmed: ControlProperty<String?> {
        let original: ControlProperty<String?> = asControlProperty()
        let values: Observable<String?> = original.map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
        let valueSink: AnyObserver<String?> = original.mapObserver { $0 }
        return ControlProperty<String?>(values: values, valueSink: valueSink)
    }
}

extension String {
    static func isEmptyOrWhiteSpace(_ text: String?) -> Bool {
        guard let text = text else { return true }
        let trimmed = text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        return trimmed.isEmpty
    }

    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
