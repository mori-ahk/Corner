//
//  Diagram.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import Foundation

struct Diagram: Equatable {
    let nodes: [Node]
}

extension Diagram {
    func layeredNodes() -> [[Node]] {
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
           
            nextLayer = nextLayer.sorted { $0.edges.count > $1.edges.count }
            currentLayer = nextLayer
        }
        
        return layers
    }
    
    func flattenLayeredNodes() -> [Node] {
        layeredNodes().flatMap { $0 }
    }
}
