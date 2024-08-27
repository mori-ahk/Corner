//
//  DiagramLayout.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct DiagramLayout: Layout {
    var nodes: [[Node]]
    var diagram: Diagram
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        let maxSize = maxSize(subviews: subviews)
        let placementProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX
        var subviewIndex = 0
        
        for layer in nodes {
            for (nodeIndex, node) in layer.enumerated() {
                var y = bounds.midY
                let incomingEdgesCount = node.incomingEdgesCount(diagram)
                let multiplier = nodeIndex - (layer.count / 2)
                
                y += CGFloat(64 * multiplier)
                if node.edges.count > 1 {
                    y += CGFloat(16 * (node.edges.count) * multiplier)
                } else {
                    y += CGFloat(32 * multiplier)
                }
                
                if incomingEdgesCount > 1 {
                    y += CGFloat(16 * (incomingEdgesCount / 2) * multiplier)
                }
                
                
                subviews[subviewIndex].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .leading,
                    proposal: placementProposal
                )
                
                subviewIndex += 1
                
            }
            let edgeLabelSizes = layer.flatMap { $0.edges.map { $0.label.count } }
            let maxLabelSize: Double = Double(edgeLabelSizes.max() ?? .zero)
            if maxLabelSize == .zero {
                x += maxSize.width + 80
            } else {
                x += maxSize.width + CGFloat(80 + (maxLabelSize * 6))
            }
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
