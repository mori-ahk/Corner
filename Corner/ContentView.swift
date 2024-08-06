//
//  ContentView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-04.
//

import SwiftUI
import CornerParser

struct ContentView: View {
    @State private var positions: [CGPoint] = []
    var nodes: [Node] = []
    
    init(nodes: [Node]) {
        self.nodes = nodes
        self._positions = State(initialValue: Array(repeating: .zero, count: nodes.count))
    }
    
    var body: some View {
        VStack {
            ZStack {
                DiagramLayout {
                    ForEach(Array(nodes.enumerated()), id: \.offset) { index, element in
                        NodeView(node: element, position: $positions[index])
                    }
                }
            }
            
            // Display the positions
            ForEach(Array(positions.enumerated()), id: \.offset) { index, position in
                Text("Node \(["A", "B", "C"][index]) position: \(position.x), \(position.y)")
            }
        }
        .coordinateSpace(.named("Diagram"))
    }
}

struct PositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

