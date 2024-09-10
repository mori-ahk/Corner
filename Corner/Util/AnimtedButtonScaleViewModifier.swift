//
//  AnimtedButtonScaleViewModifier.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-10.
//

import SwiftUI

struct AnimtedButtonScaleViewModifier: ViewModifier {
    var value: Bool
    func body(content: Content) -> some View {
        content
            .scaleEffect(
                value ? UXMetrics.buttonScaleWhenPressed : UXMetrics.buttonScaleWhenUnpressed
            )
            .animation(.spring(response: 0.4), value: value)
    }
}

extension View {
    func scaleWithAnimation(_ value: Bool) -> some View {
        modifier(AnimtedButtonScaleViewModifier(value: value))
    }
}
