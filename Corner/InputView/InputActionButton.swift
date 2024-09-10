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
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: iconName)
                .font(.headline)
                .fontWeight(.medium)
        }
        .buttonStyle(BouncyButtonStyle(foregroundColor: .white, backgroundColor: color))
        .disabled(disabled)
        .animation(.default, value: disabled)
    }
}
