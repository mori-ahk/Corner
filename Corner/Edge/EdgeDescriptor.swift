//
//  EdgeViewModel.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import SwiftUI

struct EdgeDescriptor {
    let start: EdgeAnchorPoint
    let end: EdgeAnchorPoint
    var direction: EdgeDirection
    
    init(start: EdgeAnchorPoint, end: EdgeAnchorPoint) {
        self.start = start
        self.end = end
        if start.center.y < end.center.y {
            self.direction = .down
        } else if start.center.y > end.center.y {
            self.direction = .up
        } else {
            self.direction = .leftOrRight
        }
    }
}


struct EdgeAnchorPoint {
    let origin: CGPoint
    let size: CGSize
    let center: CGPoint
    let color: Color?
    
    init(origin: CGPoint, size: CGSize, color: Color? = nil) {
        self.origin = origin
        self.size = size
        self.color = color
        center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

enum EdgeDirection {
    case up
    case down
    case leftOrRight
}
