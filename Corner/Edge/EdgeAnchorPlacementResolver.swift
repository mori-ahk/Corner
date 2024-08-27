//
//  EdgeAnchorPlacementAssigner.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-27.
//

import Foundation

struct EdgeAnchorPlacementResolver {
    let start: CGPoint
    let end: CGPoint
    let hasCrossOver: Bool
    
    init(start: CGPoint, end: CGPoint, _ hasCrossOver: Bool) {
        self.start = start
        self.end = end
        self.hasCrossOver = hasCrossOver
    }
    
    enum FlowDirection: String {
        case north
        case south
        case east
        case west
        case northeast
        case northwest
        case southeast
        case southwest
        case same
    }
    
    private func relativeDirection() -> FlowDirection {
        let dx = end.x - start.x
        let dy = end.y - start.y
        
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
        switch relativeDirection() {
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
    
    func anchorPlacements() -> (start: EdgeAnchorPlacement, end: EdgeAnchorPlacement) {
        guard let startAnchor = availableAnchors(), 
                let endAnchor = startAnchor.opposite(basedOn: relativeDirection(), hasCrossOver) 
        else { return (start: .topTrailing, end: .topLeading) }
        
        return (start: startAnchor, end: endAnchor)
    }
}
