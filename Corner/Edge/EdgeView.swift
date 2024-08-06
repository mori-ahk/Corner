//
//  EdgeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct EdgeView: View {
    let edge: Edge
    let fromPosition: CGPoint
    let toPosition: CGPoint

    var body: some View {
        Path { path in
            path.move(to: fromPosition)
            path.addLine(to: toPosition)
        }
        .stroke(edge.color, lineWidth: 2)
        .overlay(
            Text(edge.label)
                .position(x: (fromPosition.x + toPosition.x) / 2, y: (fromPosition.y + toPosition.y) / 2)
        )
    }
}
