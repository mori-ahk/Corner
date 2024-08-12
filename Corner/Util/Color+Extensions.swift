//
//  Color+Extensions.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-12.
//

import SwiftUI

public extension Color {
    static func random() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: 1
        )
    }
}
