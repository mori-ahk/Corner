//
//  InputActionButton.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-11.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let color: Color
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve)
                        .fill(disabled ? color.opacity(0.1) : color)
                        .shadow(radius: 4)
                }
        }
        .buttonStyle(.borderless)
        .disabled(disabled)
        .animation(.default, value: disabled)
    }
}
