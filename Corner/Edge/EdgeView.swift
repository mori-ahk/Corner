//
//  EdgeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct EdgeView: View {
    let edge: Edge
    let from: CGPoint
    let to: CGPoint

    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(edge.color, lineWidth: 2)
        .overlay(
            Text(edge.label)
                .position(x: (from.x + to.x) / 2, y: (from.y + to.y) / 2)
        )
    }
}
