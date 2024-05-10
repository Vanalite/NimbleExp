//
//  ThreadSafeDictionary.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/10/24.
//

import Foundation

class ThreadSafeDictionary<V: Hashable, T>: Collection {
    private var dictionary: [V: T]
    private let concurrentQueue = DispatchQueue(
        label: "Dictionary Barrier Queue",
        attributes: .concurrent
    )

    var keys: Dictionary<V, T>.Keys {
        concurrentQueue.sync {
            self.dictionary.keys
        }
    }

    var values: Dictionary<V, T>.Values {
        concurrentQueue.sync {
            self.dictionary.values
        }
    }

    var startIndex: Dictionary<V, T>.Index {
        concurrentQueue.sync {
            self.dictionary.startIndex
        }
    }

    var endIndex: Dictionary<V, T>.Index {
        concurrentQueue.sync {
            self.dictionary.endIndex
        }
    }

    init(dict: [V: T] = [V: T]()) {
        dictionary = dict
    }

    // this is because it is an apple protocol method
    func index(after i: Dictionary<V, T>.Index) -> Dictionary<V, T>.Index {
        concurrentQueue.sync {
            self.dictionary.index(after: i)
        }
    }

    // swiftlint:enable identifier_name

    subscript(key: V) -> T? {
        get {
            concurrentQueue.sync {
                self.dictionary[key]
            }
        }
        set(newValue) {
            concurrentQueue.async(flags: .barrier) { [weak self] in
                self?.dictionary[key] = newValue
            }
        }
    }

    // has implicity get
    subscript(index: Dictionary<V, T>.Index) -> Dictionary<V, T>.Element {
        concurrentQueue.sync {
            self.dictionary[index]
        }
    }

    func removeValue(forKey key: V) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.dictionary.removeValue(forKey: key)
        }
    }

    func removeAll() {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.dictionary.removeAll()
        }
    }
}
