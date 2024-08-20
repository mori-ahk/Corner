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
}


struct EdgeAnchorPoint {
    let origin: CGPoint
    let size: CGSize
    let color: Color? 
    
    init(origin: CGPoint, size: CGSize, color: Color? = nil) {
        self.origin = origin
        self.size = size
        self.color = color
    }
}
