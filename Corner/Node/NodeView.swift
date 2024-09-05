//
//  NodeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct NodeView: View {
    @Environment(\.colorScheme) private var colorScheme
    let node: Node
    
    var body: some View {
        Text(node.id)
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(UXMetrics.Padding.twenty)
            .foregroundColor(node.color)
            .background {
                RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.eight)
                    .fill(
                        LinearGradient(
                            colors: [topGradientColor, node.color.opacity(0.2)],
                            startPoint: .top,
                            endPoint: UnitPoint(x: 0.5, y: 4)
                        )
                    )
                    .shadow(color: node.color.opacity(0.2), radius: UXMetrics.ShadowRadius.four)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }
    
    private var topGradientColor: Color {
        colorScheme == .dark ? .black : .white
    }
}
