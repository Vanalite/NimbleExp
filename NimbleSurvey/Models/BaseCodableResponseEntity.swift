//
//  BaseCodableResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RealmSwift

class BaseCodableResponseEntity: BaseCodable {
}

extension BaseCodableResponseEntity: CustomNSError {
}

extension BaseCodableResponseEntity: @unchecked Sendable {}
