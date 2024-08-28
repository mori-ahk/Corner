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
        var maxLayerCount = 0
        
        for (layerIndex, layer) in nodes.enumerated() {
            maxLayerCount = max(maxLayerCount, layer.count)
            var y = calculateInitialY(
                layerIndex: layerIndex,
                bounds: bounds,
                maxLayerCount: maxLayerCount
            )
            for (nodeIndex, node) in layer.enumerated() {
                y = placeNode(
                    node: node,
                    at: CGPoint(x: x, y: y),
                    subviews: subviews,
                    subviewIndex: &subviewIndex,
                    proposal: placementProposal
                )
                y += 64
            }
            calculateXOffset(layer, &x, maxSize)
        }
    }
    
    private func placeNode(
        node: Node,
        at point: CGPoint,
        subviews: Subviews,
        subviewIndex: inout Int,
        proposal: ProposedViewSize
    ) -> CGFloat {
        var y = point.y
        let incomingEdgesCount = node.incomingEdgesCount(diagram)
        
        if incomingEdgesCount > 1 {
            y += CGFloat((incomingEdgesCount - 1) * 32)
        }
        
        subviews[subviewIndex].place(
            at: CGPoint(x: point.x, y: y),
            anchor: .leading,
            proposal: proposal
        )
        
        subviewIndex += 1
        
        if node.edges.count > 1 {
            y += CGFloat(32 * node.edges.count)
        }
        
        return y
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
    
    private func calculateXOffset(_ layer: [Node], _ x: inout CGFloat, _ maxSize: CGSize) {
        let edgeLabelSizes = layer.flatMap { $0.edges.map { $0.label.count } }
        let maxLabelSize: Double = Double(edgeLabelSizes.max() ?? .zero)
        if maxLabelSize == .zero {
            x += maxSize.width + 80
        } else {
            x += maxSize.width + CGFloat(80 + (maxLabelSize * 6))
        }
    }
    
    private func calculateInitialY(
        layerIndex: Int,
        bounds: CGRect,
        maxLayerCount: Int
    ) -> CGFloat {
        layerIndex == 0 ? bounds.midY : bounds.midY - CGFloat(32 * maxLayerCount)
    }
}
