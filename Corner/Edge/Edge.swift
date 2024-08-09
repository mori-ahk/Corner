//
//  Edge.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI
import CornerParser

struct Edge: Identifiable, Equatable {
    let id: UUID = UUID()
    let from: String
    let to: String
    var color: Color
    var label: String
    
    init?(from edgeDecl: ASTNode.EdgeDecl) {
        self.from = edgeDecl.from
        self.to = edgeDecl.to
        self.color = .black
        self.label = ""
        
        guard !edgeDecl.attributes.isEmpty else {
            self.color = .black
            self.label = ""
            return
        }
        
        for attribute in edgeDecl.attributes {
            switch attribute {
            case .color(let colorString):
                self.color = color(from: colorString)
            case .label(let string):
                self.label = string
            }
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
        default: .teal
        }
    }
}
