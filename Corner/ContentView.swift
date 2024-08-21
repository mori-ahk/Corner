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
    @State private var input: String = ""
    @State private var previousInput: String = ""
    @State private var shouldBuildDiagram: Bool = false
    private typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGRect>>
    
    var body: some View {
        HStack {
            inputSection
            if !vm.diagram.nodes.isEmpty {
                diagramSection
                    .transition(.blurReplace)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(UXMetrics.Padding.twentyFour)
        .onPreferenceChange(Key.self) { bounds in
            self.nodesBounds = bounds
        }
        .animation(.default, value: vm.diagram)
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
                vm.diagram = Diagram()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    do {
                        try vm.diagram(for: input)
                    } catch { print(error) }
                }
            }
            
            ActionButton(title: "Clear", color: .red) {
                vm.diagram = Diagram()
            }
        }
    }
   
    @ViewBuilder
    private var diagramSection: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                diagramLayout
                edgesLayer(in: proxy)
                    .transition(.blurReplace)
            }
            .onReceive(vm.$diagram) { _ in
                vm.bounds(from: proxy, given: nodesBounds)
            }
        }
        .padding(UXMetrics.Padding.twentyFour)
    }
    
    @ViewBuilder
    private var diagramLayout: some View {
        DiagramLayout(nodes: vm.diagram.layeredNodes, diagram: vm.diagram) {
            ForEach(vm.diagram.flattenNodes) { node in
                NodeView(node: node)
                    .anchorPreference(key: Key.self, value: .bounds) { [node.id: $0] }
            }
        }
    }
    
    @ViewBuilder
    private func edgesLayer(in proxy: GeometryProxy) -> some View {
        ForEach(vm.diagram.flattenNodes) { node in
            ForEach(node.edges) { edge in
                if let edgeDescriptor = vm.allEdgeDescriptors[edge.id, default: nil],
                   let paths = vm.allPaths[edge.id] {
                    EdgeView(
                        edge: edge,
                        edgeDescriptor: edgeDescriptor,
                        intermidiatePoints: paths
                    )
                }
            }
        }
    }
}
