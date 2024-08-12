//
//  NodeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    
    var body: some View {
        Text(node.id)
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(UXMetrics.Padding.twenty)
            .foregroundColor(node.color)
            .background {
                RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.eight)
                    .fill(.background)
                    .shadow(color: node.color.opacity(0.33), radius: UXMetrics.ShadowRadius.four)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }
}
