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
    @State private var diagram: Diagram = Diagram(nodes: [])
    @State private var input: String = ""
    @State private var previousInput: String = ""

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
                guard previousInput != input else { return }
                self.previousInput = input
                self.diagram = Diagram(nodes: [])
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    do {
                        try vm.diagram(for: input)
                    } catch { print(error) }
                }
            }
            
            ActionButton(title: "Clear", color: .red) {
                self.diagram = Diagram(nodes: [])
            }
        }
    }
   
    @ViewBuilder
    private var diagramSection: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                diagramLayout
                edgesLayer(in: proxy)
            }
        }
        .padding(UXMetrics.Padding.twentyFour)
    }
    
    @ViewBuilder
    private var diagramLayout: some View {
        DiagramLayout(nodes: diagram.layeredNodes) {
            ForEach(diagram.flattenNodes) { node in
                NodeView(node: node)
                    .transition(.blurReplace)
                    .anchorPreference(key: Key.self, value: .bounds) { [node.id: $0] }
            }
        }
    }
    
    @ViewBuilder
    private func edgesLayer(in proxy: GeometryProxy) -> some View {
        let bounds = buildBounds(with: proxy)
        ForEach(diagram.flattenNodes) { node in
            ForEach(node.edges) { edge in
                if let startAnchor = nodesBounds[edge.from],
                   let endAnchor = nodesBounds[edge.to],
                   let endNode = diagram.flattenNodes.first(where: { $0.id == edge.to }) {
                    EdgeView(
                        edge: edge,
                        startPoint: proxy[startAnchor].origin,
                        endPoint: proxy[endAnchor].origin,
                        startNodeSize: proxy[startAnchor].size,
                        endNodeSize: proxy[endAnchor].size,
                        startColor: node.color,
                        endColor: endNode.color,
                        nodesBounds: bounds
                    )
                    .id(edge.from + edge.to)
                }
            }
        }
    }
    
    private func buildBounds(with proxy: GeometryProxy) -> [Node.ID: CGRect] {
        var result: [Node.ID : CGRect] = [:]
        for (key, value) in nodesBounds {
            result[key, default: .zero] = proxy[value]
        }
        
        return result
    }
}
