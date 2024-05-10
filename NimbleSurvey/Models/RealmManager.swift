//
//  RealmManager.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation
import RealmSwift

class RealmManager {

    static let shared = RealmManager()

    fileprivate var internalMainThreadRealm: Realm!
    var mainThreadRealm: Realm {
        if Thread.isMainThread {
            if internalMainThreadRealm == nil {
                internalMainThreadRealm = try! Realm()
            }
            return internalMainThreadRealm
        } else {
            fatalError("mainThreadRealm should be used only on main thread")
        }
    }
}
