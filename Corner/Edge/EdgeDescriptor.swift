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
            if abs(start.center.y - end.center.y) < 64 {
                self.direction = .slightlyDown
            } else {
                self.direction = .down
            }
        } else if start.center.y > end.center.y {
            if abs(start.center.y - end.center.y) < 64 {
                self.direction = .slightlyUp
            } else {
                self.direction = .up
            }
        } else {
            self.direction = .leftOrRight
        }
        
        var modifiedPlacement: EdgeAnchorPlacement = .topTrailing
        switch placement {
        case .topTrailing, .trailing:
            switch direction {
            case .up:
                modifiedPlacement = .topTrailing
            case .down:
                modifiedPlacement = .bottomTrailing
            default: modifiedPlacement = .trailing
            }
        case .bottomTrailing:
            switch direction {
            case .up:
                modifiedPlacement = .trailing
            default: modifiedPlacement = .bottomTrailing
            }
        default:
            modifiedPlacement = placement
        }
        self.start = EdgeAnchor(start, modifiedPlacement)
        self.end = EdgeAnchor(end, modifiedPlacement.opposite(basedOn: direction))
    }
}
