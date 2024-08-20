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
    var nodesBounds: [Node.ID : CGRect]
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    private let startNodeSize: CGSize
    private let endNodeSize: CGSize
    private let startColor: Color
    private var diagramViewModel: DiagramViewModel
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
        nodesBounds: [Node.ID: CGRect],
        diagramViewModel: DiagramViewModel
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
        self.nodesBounds = nodesBounds
        self.diagramViewModel = diagramViewModel
        self.hOffset = .zero
        self.vOffset = .zero
        self.intermidiatePoints = []
        self.hOffset = edge.placement.horizontalOffset(startNodeSize)
        self.vOffset = edge.placement.verticalOffset
        if adjustedPoints.start.y == adjustedPoints.end.y {
//            print("Adding adjusted")
            self.diagramViewModel.addPoint(adjustedPoints.start)
        } else {
            self.intermidiatePoints.append(firstPoint)
            self.diagramViewModel.addPoint(intermidiatePoints[0])
            self.intermidiatePoints.append(secondPoint)
            self.diagramViewModel.addPoint(intermidiatePoints[1])
        }
//        dump(self.diagramViewModel.allIntermidiatePoints)
    }
    
    
    var body: some View {
        ZStack {
            path
                .stroke(
                    startColor.opacity(0.75),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
                .overlay(edgeLabel)
            
            createNodeMarker(at: adjustedPoints.start, color: startColor)
            createNodeMarker(at: adjustedPoints.end, color: startColor)
        }
    }

    private var path: Path {
        Path { path in
            path.move(to:  adjustedPoints.start)
            if adjustedPoints.start.y != adjustedPoints.end.y {
                path.addLine(to: intermidiatePoints[0])
                if intermidiatePoints[0].y != adjustedPoints.end.y {
                    path.addLine(to: intermidiatePoints[1])
                }
                if edge.placement == .top {
                    path.addLine(to: intermidiatePoints[2])
                }
            }
            path.addLine(to: adjustedPoints.end)
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

    private var firstPoint: CGPoint {
        var nodeIntersectionOffset: CGFloat = .zero
        var edgeIntersectionHOffset: CGFloat = .zero
        var edgeIntersectionVOffset: CGFloat = .zero
        
        while doesIntersect(with: firstIntermediatePoint(nodeIntersectionOffset, edgeIntersectionHOffset, edgeIntersectionVOffset)) {
            nodeIntersectionOffset += 16
        }
       
        var edgeIntersection = edgeContais(firstIntermediatePoint(nodeIntersectionOffset, edgeIntersectionHOffset, edgeIntersectionVOffset))
        if edgeIntersection.hasSameX {
            edgeIntersectionHOffset += 16
        }
        
        if edgeIntersection.hasSameY {
            edgeIntersectionVOffset += 16
        }
        
        return firstIntermediatePoint(nodeIntersectionOffset, edgeIntersectionHOffset, edgeIntersectionVOffset)
    }
    
    private var secondPoint: CGPoint {
        var nodeIntersectionOffset: CGFloat = .zero
        var edgeIntersectionHOffset: CGFloat = .zero
        var edgeIntersectionVOffset: CGFloat = .zero
            
        while doesIntersect(
            with: secondIntermediatePoint(
                nodeIntersectionOffset,
                edgeIntersectionHOffset,
                edgeIntersectionVOffset
            )
        ) {
            nodeIntersectionOffset += 16
        }
        
        var edgeIntersection = edgeContais(
            secondIntermediatePoint(
                nodeIntersectionOffset,
                edgeIntersectionHOffset,
                edgeIntersectionVOffset
            )
        )
        
//        if edgeIntersection.hasSameX {
//            edgeIntersectionHOffset += 16
//        }
//        
//        if edgeIntersection.hasSameY {
//            edgeIntersectionVOffset += 16
//        }

        return secondIntermediatePoint(
            nodeIntersectionOffset,
            edgeIntersectionHOffset,
            edgeIntersectionVOffset
        )
    }
    
    private func firstIntermediatePoint(
        _ nodeIntersectionOffset: CGFloat,
        _ edgeIntersectionHOffset: CGFloat,
        _ edgeIntersectionVOffset: CGFloat
    ) -> CGPoint {
        let xStart = adjustedPoints.start.x
        let yStart = adjustedPoints.start.y
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: xStart + hOffset + edgeIntersectionHOffset, y: yStart + edgeIntersectionVOffset)
        case .top:
            return CGPoint(x: xStart + edgeIntersectionHOffset, y: yStart + vOffset + edgeIntersectionVOffset)
        case .topLeading:
            return CGPoint(x: xStart + hOffset + edgeIntersectionHOffset, y: yStart + edgeIntersectionVOffset)
        case .topTrailing:
            return CGPoint(x: xStart + nodeIntersectionOffset + edgeIntersectionHOffset, y: adjustedPoints.end.y + edgeIntersectionVOffset)
        case .bottomTrailing:
//            let y = padding == .zero ? adjustedPoints.end.y : yStart
            return CGPoint(x: xStart + nodeIntersectionOffset + edgeIntersectionHOffset, y: adjustedPoints.end.y + edgeIntersectionVOffset)
        case .bottom, .bottomLeading:
            return CGPoint(x: xStart + edgeIntersectionHOffset, y: adjustedPoints.end.y - nodeIntersectionOffset + edgeIntersectionVOffset)
        }
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
    
    private func doesIntersect(with point: CGPoint) -> Bool {
        guard point != adjustedPoints.end || point != adjustedPoints.start else { return false }
//        print("\(edge.from) -> \(edge.to)")
        for (key, value) in nodesBounds {
            if value.contains(point) {
                return true
            } else { continue }
        }
        
        return false
    }
    
    private func edgeContais(_ point: CGPoint) -> (hasSameX: Bool, hasSameY: Bool) {
        guard point != adjustedPoints.end || point != adjustedPoints.start else { return (false, false) }
        let hasSameX = diagramViewModel.allIntermidiatePoints.contains { $0.x == point.x }
        let hasSameY = diagramViewModel.allIntermidiatePoints.contains { $0.y == point.y }
        return (hasSameX, hasSameY)
    }
}

