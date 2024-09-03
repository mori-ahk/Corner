//
//  CircleMarker.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-03.
//

import SwiftUI

struct ShapeMarker<S: Shape>: View {
    let shape: S
    let color: Color
    let point: CGPoint
    let size: CGFloat
    let hasBackground: Bool
    let rotationAngle: CGFloat
    
    var body: some View {
        ZStack {
            shape
                .fill(color.opacity(0.2))
                .frame(width: size, height: size)
                .position(point)
                .opacity(hasBackground ? 1 : 0)
            shape
                .fill(color)
                .rotationEffect(Angle(degrees: rotationAngle))
                .frame(width: size / 2, height: size / 2)
                .position(point)
        }
    }
}
