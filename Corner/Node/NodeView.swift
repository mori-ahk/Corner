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
        VStack(alignment: .leading, spacing: 2) {
            Text(node.id)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(node.color)
                .frame(maxWidth: .infinity, alignment: doesHaveDesc ? .leading : .center)
            if let desc = node.desc {
                Text(desc)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .frame(maxWidth: 200, alignment: .topLeading)
            }
        }
        .padding(UXMetrics.Padding.twenty)
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
    
    private var doesHaveDesc: Bool {
        return node.desc != nil
    }
}
