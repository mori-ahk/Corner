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
            if to.y != from.y {
                path.move(to: from)
                path.addLine(to: CGPoint(x: from.x, y: to.y))
                path.addLine(to: to)
               
            } else {
                path.move(to: from)
                path.addLine(to: to)
            }
        }
        .stroke(edge.color.opacity(0.4), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        .overlay {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .padding(8)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
                    .position(x: (from.x + to.x) / 2, y: to.y)
            }
        }
    }
}
