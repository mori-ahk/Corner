//
//  ArrowMarker.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-03.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topPoint = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        path.move(to: topPoint)
        path.addLine(to: bottomLeftPoint)
        path.addLine(to: bottomRightPoint)
        path.closeSubpath()
        
        return path
    }
}
