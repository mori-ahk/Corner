//
//  EdgeAnchor.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import SwiftUI

struct EdgeAnchor {
    let origin: CGPoint
    let size: CGSize
    let center: CGPoint
    var placement: EdgeAnchorPlacement
    var adjustedPoint: CGPoint
    let color: Color?

    init(origin: CGPoint, size: CGSize, color: Color? = nil) {
        self.origin = CGPoint(x: Int(origin.x), y: Int(origin.y))
        self.size = CGSize(width: Int(size.width), height: Int(size.height))
        self.color = color
        center = CGPoint(x: Int(origin.x + size.width / 2), y: Int(origin.y + size.height / 2))
        self.placement = .bottom
        self.adjustedPoint = .zero
    }
    
    mutating func calculateAdjustedPoint() {
        let padding: CGFloat = UXMetrics.Padding.sixteen
        let halfWidth = (size.width - padding) / 2
        let halfHeight = (size.height - padding) / 2
        let offset = placementOffset(placement, halfWidth: halfWidth, halfHeight: halfHeight)
        self.adjustedPoint = CGPoint(x: Int(center.x + offset.x), y: Int(center.y + offset.y))
    }

    private func placementOffset(_ placement: EdgeAnchorPlacement, halfWidth: CGFloat, halfHeight: CGFloat) -> CGPoint {
        switch placement {
        case .topTrailing: return CGPoint(x: halfWidth, y: -halfHeight)
        case .trailing: return CGPoint(x: halfWidth, y: 0)
        case .bottomTrailing: return CGPoint(x: halfWidth, y: halfHeight)
        case .bottom: return CGPoint(x: 0, y: halfHeight)
        case .bottomLeading: return CGPoint(x: -halfWidth, y: halfHeight)
        case .leading: return CGPoint(x: -halfWidth, y: 0)
        case .topLeading: return CGPoint(x: -halfWidth, y: -halfHeight)
        case .top: return CGPoint(x: 0, y: -halfHeight)
        }
    }
}
