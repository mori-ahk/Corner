//
//  EdgeViewModel.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import SwiftUI

struct EdgeDescriptor {
    var start: EdgeAnchor
    var end: EdgeAnchor
    var direction: FlowDirection
    let hasCrossOver: Bool
    
    init(start: EdgeAnchor, end: EdgeAnchor, _ hasCrossOver: Bool) {
        self.start = start
        self.end = end
        self.hasCrossOver = hasCrossOver
        self.direction = .east
        self.direction = flowDirection()
        let anchorPlacements = anchorPlacements()
        
        self.start.placement = anchorPlacements.start
        self.end.placement = anchorPlacements.end
        self.start.calculateAdjustedPoint()
        self.end.calculateAdjustedPoint()
    }
    
    private func flowDirection() -> FlowDirection {
        let dx = end.center.x - start.center.x
        let dy = end.center.y - start.center.y
        
        if dx == 0 && dy == 0 {
            return .same
        }
        
        let angle = (atan2(dy, dx) * 180 / .pi) * -1
        
        switch angle {
        case -15 ..< 15:
            return .east
        case 15 ..< 75:
            return .northeast
        case 75 ..< 105:
            return .north
        case 105 ..< 165:
            return .northwest
        case -75 ..< -15:
            return .southeast
        case -105 ..< -75:
            return .south
        case -165 ..< -105:
            return .southwest
        default:
            return .west
        }
    }
    
    private func availableAnchors() -> EdgeAnchorPlacement? {
        switch direction {
        case .east: return .trailing
        case .west: return .leading
        case .north: return hasCrossOver ? .topTrailing : .top
        case .south: return hasCrossOver ? .bottomTrailing : .bottom
        case .northeast: return .topTrailing
        case .northwest: return .topLeading
        case .southeast: return .bottomTrailing
        case .southwest: return .bottomLeading
        default: return nil
        }
    }
    
    private func anchorPlacements() -> (start: EdgeAnchorPlacement, end: EdgeAnchorPlacement) {
        guard let startAnchor = availableAnchors(),
                let endAnchor = startAnchor.opposite(basedOn: direction, hasCrossOver)
        else { return (start: .topTrailing, end: .topLeading) }
        
        return (start: startAnchor, end: endAnchor)
    }
}
