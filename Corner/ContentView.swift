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
    @State private var diagram: Diagram?
    @State private var layeredNodes: [[Node]] = []
    @State private var nodes: [Node] = []
    @State private var input: String = ""
    
    private typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGPoint>>
    
    var body: some View {
        HStack {
            inputSection
            diagramSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(24)
        .onReceive(vm.$diagram) { newDiagram in
            self.diagram = newDiagram
        }
        .onChange(of: diagram) { oldValue, newValue in
            if newValue == nil { positions.removeAll() }
            layeredNodes = newValue?.layeredNodes() ?? []
            nodes = newValue?.flattenLayeredNodes() ?? []
        }
        .onPreferenceChange(Key.self) {
            self.positions = $0
        }
        
        .animation(.default, value: nodes)
        .animation(.default, value: layeredNodes)
        .animation(.default, value: positions)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading) {
            Text("Start diagram here:")
                .font(.headline)
                .fontWeight(.semibold)
            InputTextView(
                text: $input,
                textColor: .black
            )
            Divider()
            actionButtons
        }
        .frame(maxWidth: 350, alignment: .topLeading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.15), radius: 12)
    }
    
    private var actionButtons: some View {
        HStack {
            ActionButton(title: "Generate", color: .blue) {
                do {
                    try vm.diagram(for: input)
                } catch { print(error) }
            }
            
            ActionButton(title: "Clear", color: .red) {
                self.diagram = nil
            }
        }
    }
    
    private var diagramSection: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                diagramLayout
                if !positions.isEmpty { edgesLayer(in: proxy) }
            }
        }
        .padding(24)
    }
    
    private var diagramLayout: some View {
        DiagramLayout(nodes: layeredNodes) {
            ForEach(nodes, id: \.id) { node in
                NodeView(node: node)
                    .anchorPreference(key: Key.self, value: .center) { [node.id: $0] }
                    .background(
                        GeometryReader { geometryProxy in
                            Color.clear.onAppear {
                                sizes[node.id, default: .zero] = geometryProxy.size
                            }
                        }
                    )
            }
        }
    }
    
    @ViewBuilder
    private func edgesLayer(in proxy: GeometryProxy) -> some View {
        ForEach(nodes) { node in
            ForEach(node.edges, id: \.id) { edge in
                if let fromAnchor = positions[edge.from],
                   let toAnchor = positions[edge.to],
                   let toNode = nodes.first(where: { $0.id == edge.to }) {
                    EdgeView(
                        edge: edge,
                        from: proxy[fromAnchor],
                        to: proxy[toAnchor],
                        fromNodeSize: sizes[edge.from, default: .zero],
                        toNodeSize: sizes[edge.to, default: .zero],
                        fromColor: node.color,
                        toColor: toNode.color
                    )
                }
            }
        }
    }
}
