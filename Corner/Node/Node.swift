//
//  Node.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI
import CornerParser

struct Node: Identifiable, Equatable {
    var id: String
    var color: Color
    var desc: String?
    var edges: [Edge]
    
    init?(from astNode: ASTNode) {
        guard astNode.isNode else { return nil }
        guard case let .node(nodeDecl) = astNode else { return nil }
        self.id = nodeDecl.id
        self.color = Color.random()
        self.edges = nodeDecl.edges.compactMap { Edge(from: $0) }
        
        for attribute in nodeDecl.attribute {
            switch attribute {
            case .color(let colorString):
                if let color = color(from: colorString) {
                    self.color = color
                }
            case .description(let description):
                self.desc = description
            }
        }
    }
    
    private func color(from colorString: String) -> Color? {
        switch colorString.lowercased() {
        case "blue": .blue
        case "yellow": .yellow
        case "red": .red
        case "green": .green
        case "orange": .orange
        case "indigo": .indigo
        case "black": .black
        case "white": .white
        case "mint": .mint
        case "cyan": .cyan
        case "purple": .purple
        case "pink": .pink
        default: nil
        }
    }
}

