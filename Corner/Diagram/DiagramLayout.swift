//
//  DiagramLayout.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct DiagramLayout: Layout {
    var nodes: [[Node]]
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        
        let placementProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX
        var subviewIndex = 0
        
        for layer in nodes {
            var y = bounds.minY
            for node in layer {
                let yOffset = CGFloat(20 * node.edges.count)
                y += yOffset
                
                subviews[subviewIndex].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .leading,
                    proposal: placementProposal
                )
                
                subviewIndex += 1
                y += 80
            }
            x += maxSize.width + 36
        }
    }
    
    private func maxSize(subviews: Subviews) -> CGSize {
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxSize: CGSize = subviewSizes.reduce(.zero) { currentMax, subviewSize in
            CGSize(
                width: max(currentMax.width, subviewSize.width),
                height: max(currentMax.height, subviewSize.height)
            )
        }

        return maxSize
    }
    
    private func spacing(subviews: Subviews) -> [CGFloat] {
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .horizontal
            )
        }
    }
}
