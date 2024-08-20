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
        let placementProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX
        var subviewIndex = 0
        
        for (index, layer) in nodes.enumerated() {
            var y = bounds.minY
            for node in layer {
                subviews[subviewIndex].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .leading,
                    proposal: placementProposal
                )
                
                subviewIndex += 1
                if node.edges.count > 2 {
                    y += CGFloat(64 * (node.edges.count - 1))
                } else {
                    y += 64
                }
            }
            let edgeLabelSizes = layer.flatMap { $0.edges.map { $0.label.count } }
            let maxLabelSize: Double = Double(edgeLabelSizes.max() ?? .zero)
            if maxLabelSize == .zero {
                x += maxSize.width + 64
            } else {
                x += maxSize.width + CGFloat(64 + (maxLabelSize * 6))
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
