//
//  DiagramViewModel.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI
import CornerParser
import Combine

class DiagramViewModel: ObservableObject {
    
    private let parser = CornerParser()
    private var edgePathResolver = EdgePathResolver()
    var allPaths: [Edge.ID : [CGPoint]] = [:]
    var allEdgeDescriptors: [Edge.ID : EdgeDescriptor?] = [:]
    var allNodeBounds: [Node.ID: CGRect] = [:]
    @Published var diagram: Diagram = Diagram()
    @Published var state: DiagramState = .idle
    
    @MainActor
    func diagram(for input: String) throws {
        state = .loading
        Task {
            do {
                // Temporary delay to address an issue where edges are not visible
                // after rendering multiple diagrams in quick succession.
                // The 2-second pause ensures proper edge rendering.
                try await Task.sleep(nanoseconds: 2_000_000_000)
                if let root = try parser.parse(input) {
                    let semanticErrors = parser.analyze(root)
                    if semanticErrors.isEmpty {
                        switch root {
                        case .diagram(let children):
                            let parsedNodes = children.filter { $0.isNode }
                            let nodes: [Node] = parsedNodes.compactMap { Node(from: $0) }
                            self.diagram = Diagram(nodes: nodes)
                        default: break
                        }
                        state = .loaded
                    } else {
                        state = .failed(nil, semanticErrors)
                    }
                }
            } catch let error as ParseError {
                state = .failed(error, [])
            }
        }
    }
    
    @MainActor
    func bounds(from proxy: GeometryProxy, given nodesBounds: [Node.ID: Anchor<CGRect>]) {
        guard !diagram.nodes.isEmpty else { return }
        state = .loading
        
        for (key, value) in nodesBounds {
            allNodeBounds[key, default: .zero] = proxy[value]
        }
        
        edgePathResolver.setNodeBounds(allNodeBounds)
        buildEdgeDescriptors()
        buildEdgePaths()
        
        state = .loaded
    }
   
    @MainActor 
    func clear() {
        clearAll()
        diagram = Diagram()
    }
    
    private func buildEdgeDescriptors() {
        for (index, layer) in diagram.layeredNodes.enumerated() {
            for (nodeIndex, node) in layer.enumerated() {
                for edge in node.edges {
                    var hasCrossOver: Bool = false
                    if let i = layer.firstIndex(where: { $0.id == edge.to }) {
                        hasCrossOver = abs(i - nodeIndex) > 1
                    }
                    allEdgeDescriptors[edge.id] = descriptor(for: edge, with: node.color, hasCrossOver)
                }
            }
        }
    }
    
    private func buildEdgePaths() {
        for (index, layer) in diagram.layeredNodes.enumerated() {
            for node in layer {
                for edge in node.edges {
                    if let descriptor = allEdgeDescriptors[edge.id, default: nil] {
                        allPaths[edge.id, default: []] = resolvePath(
                            from: descriptor.start,
                            to: descriptor.end,
                            with: descriptor.direction,
                            layerIndex: index
                        )
                    }
                }
            }
        }
    }
    
    private func descriptor(
        for edge: Edge,
        with startColor: Color,
        _ hasCrossOver: Bool
    ) -> EdgeDescriptor? {
        guard let start = allNodeBounds[edge.from],
              let end = allNodeBounds[edge.to] else { return nil }
        return EdgeDescriptor(
            start: EdgeAnchor(origin: start.origin, size: start.size, color: startColor),
            end: EdgeAnchor(origin: end.origin, size: end.size),
            hasCrossOver
        )
    }
    
    private func resolvePath(
        from start: EdgeAnchor,
        to end: EdgeAnchor,
        with direction: FlowDirection,
        layerIndex: Int
    ) -> [CGPoint] {
        return edgePathResolver.resolvePath(
            from: start,
            to: end,
            with: direction,
            layerIndex: layerIndex
        )
    }
    
    private func clearAll() {
        allPaths.removeAll(keepingCapacity: true)
        allEdgeDescriptors.removeAll(keepingCapacity: true)
        allNodeBounds.removeAll(keepingCapacity: true)
        edgePathResolver.clearAll()
    }
}
