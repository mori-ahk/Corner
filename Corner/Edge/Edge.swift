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
    var label: String
    
    init?(from edgeDecl: ASTNode.EdgeDecl) {
        self.from = edgeDecl.from
        self.to = edgeDecl.to
        self.label = ""
        
        guard !edgeDecl.attributes.isEmpty else {
            self.label = ""
            return
        }
        
        for attribute in edgeDecl.attributes {
            switch attribute {
            case .label(let string):
                self.label = string
            }
        }
    }
}
