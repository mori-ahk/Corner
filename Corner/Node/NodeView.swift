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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .foregroundColor(node.color)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(node.color.opacity(0.1))
                    .stroke(node.color, lineWidth: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }
}
