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
    @State private var positions: [Node.ID : Anchor<CGPoint>] = [:]
    @State private var diagram: Diagram?
    
    typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGPoint>>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                if let diagram {
                    if !positions.isEmpty {
                        ForEach(diagram.nodes) { node in
                            ForEach(Array(node.edges.enumerated()), id: \.element.id) { index, edge in
                                EdgeView(
                                    edge: edge,
                                    from: proxy[positions[edge.from]!],
                                    to: proxy[positions[edge.to]!]
                                )
                            }
                        }
                    }
                    
                    DiagramLayout(nodes: diagram.nodes) {
                        ForEach(Array(diagram.nodes.enumerated()), id: \.element.id) { index, node in
                            NodeView(node: node)
                                .anchorPreference(key: Key.self, value: .center) {
                                    [node.id: $0]
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onAppear {
            do {
                try vm.diagram(for: """
                node Parser {
                    color: blue
                    edge Parser -> Lexer {}
                }
                node Lexer { 
                    color: orange
                    edge Lexer -> SemanticChecker {}
                    edge Lexer -> TypeChecker {}
                    edge Lexer -> CodeGenerator {}
                }
                node SemanticChecker { color: green }
                node TypeChecker { color: black }
                node CodeGenerator { color: indigo }
                """)
            } catch {
                print(error)
            }
        }
        .onReceive(vm.$diagram) { newDiagram in
            self.diagram = newDiagram
        }
        .onPreferenceChange(Key.self) { value in
            self.positions = value
        }
        .animation(.default, value: diagram)
    }
}

