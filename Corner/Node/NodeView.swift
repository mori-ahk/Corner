//
//  NodeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    @Binding var position: CGPoint
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(node.color.opacity(0.1))
            .stroke(node.color, lineWidth: 2)
            .overlay(Text(node.id).foregroundColor(node.color))
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(node.color.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .padding(6)
            }
            .overlay(alignment: .topLeading) {
                Circle()
                    .fill(node.color.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .padding(6)
            }
            .background(
                GeometryReader {
                    geometry in
                    Color.clear.preference(
                        key: PositionPreferenceKey.self,
                        value: CGPoint(
                            x: geometry.frame(in: .named("Diagram")).midX,
                            y: geometry.frame(in: .named("Diagram")).midY
                        )
                    )
                }
            )
            .onPreferenceChange(PositionPreferenceKey.self) { newPosition in
                position = newPosition
            }
    }
}
