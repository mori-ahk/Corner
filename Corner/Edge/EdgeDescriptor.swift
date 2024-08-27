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
        self.start = EdgeAnchor(start, placement)
        self.end = EdgeAnchor(end, placement.opposite(basedOn: direction))
    }
}
