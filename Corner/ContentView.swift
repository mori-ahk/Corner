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
    @State private var sizes: [Node.ID : CGSize] = [:]
    @State private var layeredNodes: [[Node]] = []
    @State private var nodes: [Node] = []

    typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGPoint>>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                DiagramLayout(nodes: layeredNodes) {
                    ForEach(Array(nodes.enumerated()), id: \.element.id) { index, node in
                        NodeView(node: node)
                            .anchorPreference(key: Key.self, value: .center) {
                                [node.id: $0]
                            }
                            .background(
                                GeometryReader { geometryProxy in
                                    Color.clear.onAppear {
                                        sizes[node.id, default: .zero] = geometryProxy.size
                                    }
                                }
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                
                if !positions.isEmpty {
                    ForEach(nodes) { node in
                        ForEach(Array(node.edges.enumerated()), id: \.element.id) { index, edge in
                            EdgeView(
                                edge: edge,
                                from: proxy[positions[edge.from]!],
                                to: proxy[positions[edge.to]!],
                                fromNodeSize: sizes[edge.from, default: .zero],
                                toNodeSize: sizes[edge.to, default: .zero],
                                fromColor: node.color,
                                toColor: nodes.first { $0.id == edge.to }!.color
                            )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(24)
        .onAppear {
            do {
                try vm.diagram(for: """
                node Compiler {
                    color: blue
                    edge Compiler -> Lexer {
                        label: "input"
                    }
                }
                
                node Lexer {
                    color: green
                    edge Lexer -> Parser { label: "token" }
                }
                
                node Parser {
                    color: indigo
                    edge Parser -> SemanticChecker { label: "AST" }
                    edge Parser -> TypeChecker { label: "AST" }
                    edge Parser -> CodeGenerator { label: "AST" }
                }
                
                node SemanticChecker { color: red }
                node TypeChecker { color: yellow }
                node CodeGenerator { color: brown }
                node X {}
                """)
            } catch {
                print(error)
            }
        }
        .onReceive(vm.$diagram) { newDiagram in
            self.layeredNodes = newDiagram?.layeredNodes() ?? []
            self.nodes = newDiagram?.flattenLayeredNodes() ?? []
        }
        .onPreferenceChange(Key.self) { value in
            self.positions = value
        }
        .animation(.default, value: nodes)
        .animation(.default, value: layeredNodes)
    }
}

