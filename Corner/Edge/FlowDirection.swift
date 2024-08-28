//
//  FlowDirection.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-27.
//

import Foundation

enum FlowDirection {
    case north
    case south
    case east
    case west
    case northeast
    case northwest
    case southeast
    case southwest
    case same
    
    var isTowardsEast: Bool {
        switch self {
        case .east, .southeast, .northeast: return true
        default: return false
        }
    }
    
    var isTowardsNorth: Bool {
        switch self {
        case .north, .northeast, .northwest: return true
        default: return false
        }
    }
}

