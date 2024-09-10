//
//  BouncyButtonViewModifier.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-10.
//

import SwiftUI

struct BouncyButtonViewModifier: ViewModifier {
    var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleWithAnimation(isPressed)
    }
}

extension View {
    func bounce(_ isPressed: Bool) -> some View {
        modifier(BouncyButtonViewModifier(isPressed: isPressed))
    }
}
