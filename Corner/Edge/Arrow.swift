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
        
        // Define the points of the triangle for right-pointing
        let topPoint = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        // Move to the top point (pointing to the right)
        path.move(to: topPoint)
        
        // Draw lines to the other points
        path.addLine(to: bottomLeftPoint)
        path.addLine(to: bottomRightPoint)
        
        // Close the path to form a triangle
        path.addLine(to: topPoint)
        return path
    }
}
