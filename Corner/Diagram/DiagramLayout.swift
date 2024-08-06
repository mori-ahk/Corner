//
//  DiagramLayout.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct DiagramLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let proposedViewSize = ProposedViewSize(width: 120, height: 120)
        var nextX = bounds.minX + 80
        for index in subviews.indices {
            let position = CGPoint(x: nextX, y: bounds.minY + 60)
            subviews[index].place(
                at: position,
                anchor: .center,
                proposal: proposedViewSize
            )
            nextX += 80 + 100
        }
    }
}
