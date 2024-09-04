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
    var edges: [Edge]
    
    init?(from astNode: ASTNode) {
        guard astNode.isNode else { return nil }
        guard case let .node(nodeDecl) = astNode else { return nil }
        self.id = nodeDecl.id
        self.color = .black
        self.edges = nodeDecl.edges.compactMap { Edge(from: $0) }
        
        if let attribute = nodeDecl.attribute {
            guard case let .color(colorString) = attribute else {
                self.color = Color.random()
                return
            }
            self.color = color(from: colorString)
        } else {
            self.color = Color.random()
        }
    }
    
    private func color(from colorString: String) -> Color {
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
        default: .teal
        }
    }
}

