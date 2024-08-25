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
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .shadow(radius: 4)
                }
        }
        .buttonStyle(.borderless)
    }
}
