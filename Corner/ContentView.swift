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
    @State private var shouldHideInputView: Bool = false
    private typealias Key = CollectDictPrefKey<Node.ID, Anchor<CGRect>>
    
    var body: some View {
        HStack {
            if !shouldHideInputView {
                inputSection
                    .transition(.move(edge: .leading).combined(with: .blurReplace))
            }
            ZStack {
                switch vm.state {
                case .idle: EmptyView()
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    if !vm.diagram.nodes.isEmpty {
                        diagramSection
                            .transition(.blurReplace)
                    }
                case .failed:
                    ErrorView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(UXMetrics.Padding.twentyFour)
        .onPreferenceChange(Key.self) { bounds in
            self.nodesBounds = bounds
        }
        .animation(.default, value: vm.diagram)
        .animation(.default, value: vm.state)
        .animation(.default, value: shouldHideInputView)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading) {
            Text("Start diagram here:")
                .font(.headline)
                .fontWeight(.semibold)
            VStack {
                InputTextView(
                    text: $input,
                    textColor: .labelColor
                )
                .frame(maxHeight: .infinity, alignment: .top)

                
                if case let .failed(parseError) = vm.state {
                    if let parseError {
                        SemanticResultListItemView(errorDescription: parseError.description)
                    }
                }
               
                if let result = vm.semanticAnalysisResult {
                    SemanticResultListView(result: result)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            Divider()
            actionButtons
        }
        .frame(maxWidth: 350, alignment: .topLeading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve))
        .shadow(color: .gray.opacity(0.33), radius: UXMetrics.ShadowRadius.twelve)
    }
    
    private var actionButtons: some View {
        HStack {
            ActionButton(
                title: "Generate",
                color: .blue,
                disabled: vm.state == .loading
            ) {
                vm.clear()
                
                do {
                    try vm.diagram(for: input)
                } catch { print(error) }
            }

            ActionButton(
                title: "Clear",
                color: .red,
                disabled: vm.state == .loading
            ) {
                vm.clear()
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
            .onReceive(vm.$diagram) { _ in
                vm.bounds(from: proxy, given: nodesBounds)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(UXMetrics.Padding.twentyFour)
        .overlay(alignment: .topLeading) {
            Button {
                shouldHideInputView.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .padding()
                    .background()
                    .clipShape(.circle)
                    .shadow(radius: UXMetrics.ShadowRadius.four)
                    .rotationEffect(shouldHideInputView ? Angle(degrees: 180) : .zero)
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var diagramLayout: some View {
        DiagramLayout(diagram: vm.diagram) {
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
