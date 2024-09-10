//
//  ParserErrorView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import SwiftUI
import CornerParser

struct SemanticResultListItemView: View {
    let errorDescription: String
    let isWarning: Bool 
    
    init(errorDescription: String, isWarning: Bool = false) {
        self.errorDescription = errorDescription
        self.isWarning = isWarning
    }
    
    var body: some View {
        HStack(spacing: UXMetrics.Padding.twelve) {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(itemColor)
            
            Text(errorDescription)
                .fontWeight(.semibold)
                .foregroundStyle(itemColor)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve)
                .fill(itemColor.opacity(0.1))
                .shadow(radius: UXMetrics.ShadowRadius.four)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var itemColor: Color {
        isWarning ? .orange : .red
    }
    
    private var iconName: String {
        isWarning ? "exclamationmark.circle.fill" : "x.circle.fill"
    }
}
