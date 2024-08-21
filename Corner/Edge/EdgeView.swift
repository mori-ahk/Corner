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
    private var hOffset: CGFloat
    private var vOffset: CGFloat
    private var direction: EdgeDirection
    private var startNodeCenter: CGPoint
    private var endNodeCenter: CGPoint
    private var adjustedPoints: (start: CGPoint, end: CGPoint)
    private var intermidiatePoints: [CGPoint]
    
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
        self.direction = edgeDescriptor.direction
        self.adjustedPoints = (start: edgeDescriptor.start.adjustedPoint, end: edgeDescriptor.end.adjustedPoint)
        self.hOffset = edge.placement.horizontalOffset(startNodeSize)
        self.vOffset = edge.placement.verticalOffset
        self.intermidiatePoints = intermidiatePoints
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.addLines(intermidiatePoints)
            }
            .stroke(
                startColor.opacity(0.75),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .overlay(edgeLabel)
            
            createNodeMarker(at: adjustedPoints.start, color: startColor)
            createNodeMarker(at: adjustedPoints.end, color: startColor)
        }
    }
    
    private func createNodeMarker(at point: CGPoint, color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 10, height: 10)
                .position(point)

            Circle()
                .fill(color)
                .frame(width: 5, height: 5)
                .position(point)
        }
        .animation(.default, value: point)
    }
    
    private func secondIntermediatePoint(
        _ nodeIntersectionOffset: CGFloat,
        _ edgeIntersectionHOffset: CGFloat,
        _ edgeIntersectionVOffset: CGFloat
    ) -> CGPoint {
        let xStart = intermidiatePoints[0].x
        let yEnd = adjustedPoints.end.y
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: xStart + hOffset + edgeIntersectionHOffset, y: yEnd + edgeIntersectionVOffset)
        case .top:
            return CGPoint(x: xStart + hOffset + edgeIntersectionHOffset, y: adjustedPoints.start.y + vOffset + edgeIntersectionVOffset)
        case .topLeading:
            return CGPoint(x: xStart + hOffset + edgeIntersectionHOffset, y: yEnd + edgeIntersectionVOffset)
        case .topTrailing:
            return CGPoint(x: xStart + nodeIntersectionOffset + edgeIntersectionHOffset, y: yEnd + edgeIntersectionVOffset)
        case .bottomTrailing:
            return CGPoint(x: xStart + nodeIntersectionOffset + edgeIntersectionHOffset, y: yEnd + edgeIntersectionVOffset)
        case .bottom, .bottomLeading:
            let x = nodeIntersectionOffset == .zero ? xStart : adjustedPoints.end.x - nodeIntersectionOffset
            return CGPoint(x: x + edgeIntersectionHOffset, y: yEnd - nodeIntersectionOffset + edgeIntersectionVOffset)
        }
    }
    
    private var thirdIntermediatePoint: CGPoint {
        switch edge.placement {
        case .top:
            return CGPoint(x: adjustedPoints.start.x + hOffset, y: adjustedPoints.end.y)
        default: return .zero
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
}

