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
    @Published var allPaths: [UUID : [CGPoint]] = [:]
    @Published var allEdgeDescriptors: [UUID : EdgeDescriptor?] = [:]
    @Published var allNodeBounds: [Node.ID: CGRect] = [:]
    @Published var diagram: Diagram = Diagram()
    @Published var state: DiagramState = .idle
    
    @MainActor
    func diagram(for input: String) throws {
        state = .loading
        do {
            let ast = try parser.parse(input)
            switch ast {
            case .diagram(let children):
                let parsedNodes = children.filter { $0.isNode }
                let nodes: [Node] = parsedNodes.compactMap { Node(from: $0) }
                self.diagram = Diagram(nodes: nodes)
            default: break
            }
            state = .loaded
        } catch {
            throw error
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
        
        for (index, layer) in diagram.layeredNodes.enumerated() {
            for node in layer {
                for edge in node.edges {
                    if let descriptor = allEdgeDescriptors[edge.id, default: nil] {
                        allPaths[edge.id, default: []] = resolvePath(from: descriptor.start, to: descriptor.end, layerIndex: index)
                    }
                }
            }
        }
        
        state = .loaded
    }
   
    @MainActor 
    func clear() {
        clearAll()
        diagram = Diagram()
    }
    
    private func descriptor(for edge: Edge, with startColor: Color, _ hasCrossOver: Bool) -> EdgeDescriptor? {
        guard let start = allNodeBounds[edge.from],
              let end = allNodeBounds[edge.to] else { return nil }
        return EdgeDescriptor(
            start: EdgeAnchor(origin: start.origin, size: start.size, color: startColor),
            end: EdgeAnchor(origin: end.origin, size: end.size),
            hasCrossOver
        )
    }
    
    private func resolvePath(from start: EdgeAnchor, to end: EdgeAnchor, layerIndex: Int) -> [CGPoint] {
        let pathPonits = edgePathResolver.resolvePath(from: start, to: end, layerIndex: layerIndex)
        return pathPonits
    }
    
    @MainActor
    private func clearAll() {
        allPaths.removeAll(keepingCapacity: true)
        allEdgeDescriptors.removeAll(keepingCapacity: true)
        allNodeBounds.removeAll(keepingCapacity: true)
        edgePathResolver.clearAll()
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(x))
        hasher.combine(Int(y))
    }
}

enum DiagramState {
    case idle
    case loading
    case loaded
}
