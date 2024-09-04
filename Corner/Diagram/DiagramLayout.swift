//
//  DiagramLayout.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct DiagramLayout: Layout {
    var diagram: Diagram
    
    private enum LayoutConstants {
        static let verticalNodeSpacing: CGFloat = 64
        static let verticalEdgeSpacing: CGFloat = 32
        static let horizontalMinSpacing: CGFloat = 80
        static let labelWidthMultiplier: CGFloat = 6
        static let defaultLayerOffset: CGFloat = 32
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        let nodes = diagram.layeredNodes
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
                y += LayoutConstants.verticalNodeSpacing
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
            y += CGFloat(incomingEdgesCount - 1) * LayoutConstants.verticalEdgeSpacing
        }
        
        subviews[subviewIndex].place(
            at: CGPoint(x: point.x, y: y),
            anchor: .leading,
            proposal: proposal
        )
        
        subviewIndex += 1
        
        if node.edges.count > 1 {
            y += CGFloat(node.edges.count) * LayoutConstants.verticalEdgeSpacing
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
    
    private func calculateXOffset(_ layer: [Node], _ x: inout CGFloat, _ maxSize: CGSize) {
        let edgeLabelSizes = layer.flatMap { $0.edges.map { $0.label.count } }
        let maxLabelSize: Double = Double(edgeLabelSizes.max() ?? .zero)
        if maxLabelSize == .zero {
            x += maxSize.width + LayoutConstants.horizontalMinSpacing
        } else {
            x += maxSize.width
            + LayoutConstants.horizontalMinSpacing
            + (maxLabelSize * LayoutConstants.labelWidthMultiplier)
        }
    }
    
    private func calculateInitialY(
        layerIndex: Int,
        bounds: CGRect,
        maxLayerCount: Int
    ) -> CGFloat {
        if layerIndex == 0 {
            bounds.midY
        } else {
            bounds.midY - LayoutConstants.defaultLayerOffset * CGFloat(maxLayerCount)
        }
    }
}
