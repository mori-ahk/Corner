//
//  Diagram.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import Foundation

struct Diagram: Equatable {
    let nodes: [Node]
    var layeredNodes: [[Node]]
    var flattenNodes: [Node]
    var incomingEdgesCount: [Node.ID : Int]
    init(nodes: [Node] = []) {
        self.nodes = nodes
        self.layeredNodes = []
        self.flattenNodes = []
        self.incomingEdgesCount = [:]
        self.layeredNodes = layered()
        self.flattenNodes = layered().flatMap { $0 }
        self.incomingEdgesCount = buildIncomingEdgesCount()
    }
}

extension Diagram {
    private func layered() -> [[Node]] {
        var layers: [[Node]] = []
        var visited: Set<String> = []
        var currentLayer: [Node] = []
        
        if let startingNode = nodes.first {
            currentLayer.append(startingNode)
            visited.insert(startingNode.id)
        }
        
        while !currentLayer.isEmpty {
            layers.append(currentLayer)
            var nextLayer: [Node] = []
            
            for node in currentLayer {
                for edge in node.edges {
                    if !visited.contains(edge.to),
                       let nextNode = nodes.first(where: { $0.id == edge.to }) {
                        nextLayer.append(nextNode)
                        visited.insert(edge.to)
                    }
                }
            }
            
            currentLayer = nextLayer
        }
        
        return layers
    }
    
    private func buildIncomingEdgesCount() -> [Node.ID : Int] {
        var result: [Node.ID : Int] = [:]
        for node in nodes {
            for edge in node.edges {
                result[edge.to, default: .zero] += 1
            }
        }
        
        return result
    }
}
