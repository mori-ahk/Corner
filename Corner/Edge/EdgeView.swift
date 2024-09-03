//
//  EdgeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

import SwiftUI

struct EdgeView: View {
    let edge: Edge
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    private let startNodeSize: CGSize
    private let endNodeSize: CGSize
    private let startColor: Color
    private var startNodeCenter: CGPoint
    private var endNodeCenter: CGPoint
    private var adjustedPoints: (start: CGPoint, end: CGPoint)
    private var intermidiatePoints: [CGPoint]
    
    private enum LayoutConstants {
        static let circleMarkerSize: CGFloat = 10
        static let arrowMarkerSize: CGFloat = 15
    }
    
    init(
        edge: Edge,
        edgeDescriptor: EdgeDescriptor,
        intermidiatePoints: [CGPoint]
    ) {
        self.edge = edge
        self.startPoint = edgeDescriptor.start.origin
        self.endPoint = edgeDescriptor.end.origin
        self.startNodeSize = edgeDescriptor.start.size
        self.endNodeSize = edgeDescriptor.end.size
        self.startColor = edgeDescriptor.start.color ?? .black
        self.startNodeCenter = edgeDescriptor.start.center
        self.endNodeCenter = edgeDescriptor.end.center
        self.adjustedPoints = (start: edgeDescriptor.start.adjustedPoint, end: edgeDescriptor.end.adjustedPoint)
        self.intermidiatePoints = intermidiatePoints
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.addLines(intermidiatePoints)
            }
            .stroke(
                startColor,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .overlay(edgeLabel)
            
            ShapeMarker(
                shape: Circle(),
                color: startColor,
                point: adjustedPoints.start,
                size: LayoutConstants.circleMarkerSize,
                hasBackground: true,
                rotationAngle: 0
            )

            ShapeMarker(
                shape: Arrow(),
                color: startColor,
                point: CGPoint(x: adjustedPoints.end.x, y: adjustedPoints.end.y - 0.25),
                size: LayoutConstants.arrowMarkerSize,
                hasBackground: false,
                rotationAngle: arrowRotationAngle
            )
        }
    }
    
    private var edgeLabel: some View {
        return Group {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(UXMetrics.Padding.eight)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.eight))
                    .shadow(radius: UXMetrics.ShadowRadius.four)
                    .position(x: (adjustedPoints.start.x + adjustedPoints.end.x) / 2, y: adjustedPoints.end.y)
            }
        }
    }
    
    private var arrowRotationAngle: CGFloat {
        guard let arrowDirection else { return 0 }
        return arrowDirection.rotationAngle
    }
    
    /* 
    Arrow direction is calculated using on the last two points
    used for drawing the edge path. This is because some edges don't necessarily follow
    flow direction of edge descriptor.
    */
    private var arrowDirection: ArrowDirection? {
        var lastTwoPoints = intermidiatePoints.suffix(2)
        guard !lastTwoPoints.isEmpty, lastTwoPoints.count == 2 else { return nil }
        let firstPoint = lastTwoPoints.removeFirst()
        let secondPoint = lastTwoPoints.removeFirst()
        return ArrowDirection.from(firstPoint, to: secondPoint)
    }
}

