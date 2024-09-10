//
//  BouncyButtonStyle.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-10.
//

import SwiftUI

struct BouncyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    var foregroundColor: Color
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        let currentBackgroundColor = backgroundColorForState(isPressed: configuration.isPressed)
        
        return configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(foregroundColor)
            .background {
                RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve)
                    .fill(currentBackgroundColor)
                    .shadow(color: backgroundColor.opacity(0.33), radius: UXMetrics.ShadowRadius.six)
            }
            .bounce(configuration.isPressed)
    }

    private func backgroundColorForState(isPressed: Bool) -> Color {
        if isEnabled {
            return isPressed ? backgroundColor.opacity(0.8) : backgroundColor
        } else {
            return backgroundColor.opacity(0.1)
        }
    }
}

