//
//  CollectDictPrefKey.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct CollectDictPrefKey<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key : Value] { [:] }
    static func reduce(value: inout [Key : Value], nextValue: () -> [Key : Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
