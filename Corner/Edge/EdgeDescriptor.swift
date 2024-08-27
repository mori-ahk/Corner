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
    
    init(start: EdgeAnchor, end: EdgeAnchor, _ hasCrossOver: Bool) {
        self.start = start
        self.end = end
        
        let anchorPlacements = EdgeAnchorPlacementResolver(
            start: start.center,
            end: end.center,
            hasCrossOver
        ).anchorPlacements()
        
        self.start.placement = anchorPlacements.start
        self.end.placement = anchorPlacements.end
        self.start.calculateAdjustedPoint()
        self.end.calculateAdjustedPoint()
    }
}
