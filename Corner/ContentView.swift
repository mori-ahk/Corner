//
//  ContentView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-04.
//

import SwiftUI
import CornerParser

struct ContentView: View {
    @StateObject private var vm = DiagramViewModel()
    @State private var positions: [CGPoint] = []
    @State private var diagram: Diagram?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let diagram {
                DiagramLayout {
                    ForEach(Array(diagram.nodes.enumerated()), id: \.element.id) { index, element in
                        NodeView(node: element, position: $positions[index])
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onAppear {
            do {
                try vm.diagram(for: """
                node Parser { color: blue }
                node Lexer { color: orange }
                node SemanticAnalyzer { color: green }
                node TypeChecker { color: mint }

                edge A -> B { label: "eddge" }
                """)
            } catch {
                print(error)
            }
        }
        .onReceive(vm.$diagram) { newDiagram in
            self.diagram = newDiagram
            positions.removeAll(keepingCapacity: true)
            positions = Array(repeating: .zero, count: diagram?.nodes.count ?? .zero)
        }
        .coordinateSpace(.named("Diagram"))
        .animation(.default, value: diagram)
    }
}

struct PositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

