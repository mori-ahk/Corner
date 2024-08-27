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

