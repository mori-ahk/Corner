//
//  EdgeViewModel.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import SwiftUI

struct EdgeDescriptor {
    let start: EdgeAnchor
    let end: EdgeAnchor
    var direction: EdgeDirection
    
    init(start: EdgeAnchor, end: EdgeAnchor, placement: EdgeAnchorPlacement) {
        if start.center.y < end.center.y {
            self.direction = .down
        } else if start.center.y > end.center.y {
            self.direction = .up
        } else {
            self.direction = .leftOrRight
        }
        self.start = EdgeAnchor(start, placement)
        self.end = EdgeAnchor(end, placement.opposite(basedOn: direction))
    }
}

struct EdgeAnchor {
    let origin: CGPoint
    let size: CGSize
    let center: CGPoint
    let placement: EdgeAnchorPlacement
    var adjustedPoint: CGPoint
    let color: Color?

    init(origin: CGPoint, size: CGSize, color: Color? = nil) {
        self.origin = origin
        self.size = size
        self.color = color
        center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
        self.placement = .top
        self.adjustedPoint = .zero
    }
    
    init(_ anchor: EdgeAnchor, _ placement: EdgeAnchorPlacement) {
        self.init(origin: anchor.origin, size: anchor.size, color: anchor.color)
        self.adjustedPoint = .zero
        self.adjustedPoint = calculateAdjustedPoint(placement: placement)
    }
   
    private func calculateAdjustedPoint(placement: EdgeAnchorPlacement) -> CGPoint {
        let padding: CGFloat = 16
        let halfWidth = (size.width - padding) / 2
        let halfHeight = (size.height - padding) / 2
        
        let offset = placementOffset(placement, halfWidth: halfWidth, halfHeight: halfHeight)
        
        return CGPoint(x: Int(center.x + offset.x), y: Int(center.y + offset.y))
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

enum EdgeDirection {
    case up
    case down
    case leftOrRight
}
