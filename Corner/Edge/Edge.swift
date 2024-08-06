//
//  Edge.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct Edge: Identifiable {
    let id: UUID = UUID()
    let from: String
    let to: String
    let color: Color
    let label: String
}
