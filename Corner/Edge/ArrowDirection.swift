//
//  ArrowDirection.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-03.
//

import Foundation

enum ArrowDirection {
    case east
    case west
    case north
    case south
   
    var rotationAngle: CGFloat {
        switch self {
        case .east: return 0
        case .west: return 180
        case .north: return -90
        case .south: return 90
        }
    }
    
    static func from(_ start: CGPoint, to end: CGPoint) -> ArrowDirection {
        // If two nodes are vertically aligned
        if start.x == end.x {
            return start.y > end.y ? .north : .south
        }
       
        // If two nodes are horizontally aligned
        if start.y == end.y {
            return start.x > end.x ? .west : .east
        }
        
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        let angle = (atan2(dy, dx) * 180 / .pi) * -1
        
        switch angle {
        case -80 ..< 80:
            return .east
        case 80 ..< 100:
            return .north
        case -100 ..< 100:
            return .west
        default:
            return .south
        }
    }
}
