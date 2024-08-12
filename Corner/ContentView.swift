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
    @State private var nodesBounds: [Node.ID : Anchor<CGRect>] = [:]
    @State private var diagram: Diagram?
    @State private var layeredNodes: [[Node]] = []
    @State private var nodes: [Node] = []
    @State private var input: String = ""
    
    private typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGRect>>
    
    var body: some View {
        HStack {
            inputSection
            diagramSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(UXMetrics.Padding.twentyFour)
        .onReceive(vm.$diagram) { newDiagram in
            self.diagram = newDiagram
        }
        .onChange(of: diagram) { oldValue, newValue in
            if newValue == nil { nodesBounds.removeAll() }
            layeredNodes = newValue?.layeredNodes() ?? []
            nodes = newValue?.flattenLayeredNodes() ?? []
        }
        .onPreferenceChange(Key.self) {
            self.nodesBounds = $0
        }
        .animation(.default, value: diagram)
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
        .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve))
        .shadow(color: .gray.opacity(0.15), radius: UXMetrics.ShadowRadius.twelve)
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
                edgesLayer(in: proxy)
            }
        }
        .padding(UXMetrics.Padding.twentyFour)
    }
    
    private var diagramLayout: some View {
        DiagramLayout(nodes: layeredNodes) {
            ForEach(nodes) { node in
                NodeView(node: node)
                    .anchorPreference(key: Key.self, value: .bounds) { [node.id: $0] }
            }
        }
    }
    
    @ViewBuilder
    private func edgesLayer(in proxy: GeometryProxy) -> some View {
        ForEach(nodes) { node in
            ForEach(node.edges) { edge in
                if let fromAnchor = nodesBounds[edge.from],
                   let toAnchor = nodesBounds[edge.to],
                   let toNode = nodes.first(where: { $0.id == edge.to }) {
                    EdgeView(
                        edge: edge,
                        from: proxy[fromAnchor].origin,
                        to: proxy[toAnchor].origin,
                        fromNodeSize: proxy[fromAnchor].size,
                        toNodeSize: proxy[toAnchor].size,
                        fromColor: node.color,
                        toColor: toNode.color
                    )
                }
            }
        }
    }
}
