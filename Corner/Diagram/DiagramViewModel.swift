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
   
    @Published var diagram: Diagram?
    
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
}
