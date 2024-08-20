//
//  DiagramViewModel.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI
import CornerParser

class DiagramViewModel: ObservableObject {
    
    private let parser = CornerParser()
    
    var allIntermidiatePoints: Set<CGPoint> = Set()
    @Published var allNodeBounds: [Node.ID: CGRect] = [:]
    @Published var diagram: Diagram = Diagram()
    
    @MainActor
    func diagram(for input: String) throws {
        do {
            let ast = try parser.parse(input)
            switch ast {
            case .diagram(let children):
                let parsedNodes = children.filter { $0.isNode }
                let nodes: [Node] = parsedNodes.compactMap { Node(from: $0) }
                self.diagram = Diagram(nodes: nodes)
            default: break
            }
        } catch {
            throw error
        }
    }
    
    func addPoint(_ point: CGPoint) {
        self.allIntermidiatePoints.insert(CGPoint(x: CGFloat(Int(point.x)), y: CGFloat(Int(point.y))))
    }
    
    @MainActor
    func bounds(from proxy: GeometryProxy, given nodesBounds: [Node.ID: Anchor<CGRect>]) {
        for (key, value) in nodesBounds {
            allNodeBounds[key, default: .zero] = proxy[value]
        }
    }
   
    func descriptor(for edge: Edge, with startColor: Color) -> EdgeDescriptor? {
        guard let start = allNodeBounds[edge.from],
              let end = allNodeBounds[edge.to] else { return nil }
        return EdgeDescriptor(
            start: EdgeAnchorPoint(
                origin: start.origin,
                size: start.size,
                color: startColor
            ),
            end: EdgeAnchorPoint(
                origin: end.origin,
                size: end.size
            )
        )
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(x))
        hasher.combine(Int(y))
    }
}
