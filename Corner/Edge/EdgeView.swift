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
    let startPoint: CGPoint
    let endPoint: CGPoint
    let startNodeSize: CGSize
    let endNodeSize: CGSize
    let startColor: Color
    let endColor: Color
    private var startNodeCenter: CGPoint
    private var endNodeCenter: CGPoint
    private var adjustedPoints: (start: CGPoint, end: CGPoint)
    
    init(
        edge: Edge,
        startPoint: CGPoint,
        endPoint: CGPoint,
        startNodeSize: CGSize,
        endNodeSize: CGSize,
        startColor: Color,
        endColor: Color
    ) {
        self.edge = edge
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.startNodeSize = startNodeSize
        self.endNodeSize = endNodeSize
        self.startColor = startColor
        self.endColor = endColor
        self.startNodeCenter = .zero
        self.endNodeCenter = .zero
        self.adjustedPoints = (.zero, .zero)
        self.startNodeCenter = CGPoint(x: startPoint.x + startNodeSize.width / 2, y: startPoint.y + startNodeSize.height / 2)
        self.endNodeCenter = CGPoint(x: endPoint.x + endNodeSize.width / 2, y: endPoint.y + endNodeSize.height / 2)
        let start = adjustedPoint(for: startNodeCenter, nodeSize: startNodeSize, placement: edge.placement)
        let end = adjustedPoint(for: endNodeCenter, nodeSize: endNodeSize, placement: edge.placement.opposite)
        self.adjustedPoints = (start: start, end: end)
    }
    
    
    var body: some View {
        ZStack {
            createPath()
                .stroke(
                    startColor.opacity(0.75),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                .overlay(edgeLabel)
            
            createNodeMarker(at: adjustedPoints.start, color: startColor)
            createNodeMarker(at: adjustedPoints.end, color: endColor)
        }
    }

    private func createPath() -> Path {
        return Path { path in
            path.move(to:  adjustedPoints.start)
            if startPoint.y != endPoint.y {
                path.addLine(to: firstIntermediatePoint)
                path.addLine(to: secondIntermediatePoint)
                if edge.placement == .top {
                    path.addLine(to: thirdIntermediatePoint)
                }
            }
            path.addLine(to: adjustedPoints.end)
        }
    }
    
    private func adjustedPoint(for center: CGPoint, nodeSize: CGSize, placement: EdgePlacement) -> CGPoint {
        let padding: CGFloat = 16
        let halfWidth = (nodeSize.width - padding) / 2
        let halfHeight = (nodeSize.height - padding) / 2
        
        let offset = placementOffset(placement, halfWidth: halfWidth, halfHeight: halfHeight)
        
        return CGPoint(x: center.x + offset.x, y: center.y + offset.y)
    }

    private func placementOffset(_ placement: EdgePlacement, halfWidth: CGFloat, halfHeight: CGFloat) -> CGPoint {
        switch placement {
        case .topTrailing: return CGPoint(x: halfWidth, y: -halfHeight)
        case .trailing: return CGPoint(x: halfWidth, y: 0)
        case .bottomTrailing: return CGPoint(x: halfWidth, y: halfHeight)
        case .bottom: return CGPoint(x: 0, y: halfHeight + 2)
        case .bottomLeading: return CGPoint(x: -halfWidth, y: halfHeight)
        case .leading: return CGPoint(x: -halfWidth, y: 0)
        case .topLeading: return CGPoint(x: -halfWidth, y: -halfHeight)
        case .top: return CGPoint(x: 0, y: -halfHeight)
        }
    }

    private func createNodeMarker(at point: CGPoint, color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 12, height: 12)
                .position(point)

            Circle()
                .fill(color.opacity(0.75))
                .frame(width: 6, height: 6)
                .position(point)
        }
        .animation(.default, value: point)
    }

    private var firstIntermediatePoint: CGPoint {
        let start = adjustedPoints.start
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: start.x + horizontalOffset(for: edge.placement), y: startNodeCenter.y)
        case .top:
            return CGPoint(x: start.x, y: start.y + verticalOffset(for: edge.placement))
        case .topLeading:
            return CGPoint(x: start.x + horizontalOffset(for: edge.placement), y: start.y)
        default:
            return CGPoint(x: start.x, y: endNodeCenter.y)
        }
    }
    
    private var secondIntermediatePoint: CGPoint {
        let start = adjustedPoints.start
        let offset = horizontalOffset(for: edge.placement)
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: start.x + offset, y: endNodeCenter.y)
        case .top:
            return CGPoint(x: start.x + offset, y: start.y + verticalOffset(for: edge.placement))
        case .topLeading:
            return CGPoint(x: start.x + offset, y: endNodeCenter.y)
        default:
            return CGPoint(x: start.x, y: endNodeCenter.y)
        }
    }
    
    private var thirdIntermediatePoint: CGPoint {
        switch edge.placement {
        case .top:
            return CGPoint(x: adjustedPoints.start.x + horizontalOffset(for: edge.placement), y: endNodeCenter.y)
        default: return .zero
        }
    }

    private func horizontalOffset(for placement: EdgePlacement) -> CGFloat {
        switch placement {
        case .trailing: 16
        case .leading: -16
        case .top: -(startNodeSize.width / 2) - 24
        case .topLeading: -24
        default: .zero
        }
    }
    
    private func verticalOffset(for placement: EdgePlacement) -> CGFloat {
        switch placement {
        case .top: -16
        default: .zero
        }
    }

    private var edgeLabel: some View {
        let yPosition = edge.placement == .topTrailing ? (endNodeCenter.y / 2) - 20 : endNodeCenter.y
        return Group {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .padding(UXMetrics.Padding.eight)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.eight))
                    .shadow(radius: UXMetrics.ShadowRadius.four)
                    .position(x: (startNodeCenter.x + endNodeCenter.x) / 2, y: yPosition)
            }
        }
    }
}

extension EdgePlacement {
    var opposite: EdgePlacement {
        switch self {
        case .topTrailing: return .topLeading
        default: return .leading
        }
    }
}
