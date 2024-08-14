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
    private var hOffset: CGFloat
    private var vOffset: CGFloat
    private var direction: Direction
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
        self.hOffset = .zero
        self.vOffset = .zero
        self.direction = .leftOrRight
        self.startNodeCenter = .zero
        self.endNodeCenter = .zero
        self.adjustedPoints = (.zero, .zero)
        self.startNodeCenter = CGPoint(x: startPoint.x + startNodeSize.width / 2, y: startPoint.y + startNodeSize.height / 2)
        self.endNodeCenter = CGPoint(x: endPoint.x + endNodeSize.width / 2, y: endPoint.y + endNodeSize.height / 2)
        self.hOffset = horizontalOffset(for: edge.placement)
        self.vOffset = verticalOffset(for: edge.placement)
        if startNodeCenter.y < endNodeCenter.y {
            self.direction = .down
        } else if startNodeCenter.y > endNodeCenter.y {
            self.direction = .up
        } else {
            self.direction = .leftOrRight
        }
        let start = adjustedPoint(for: startNodeCenter, nodeSize: startNodeSize, placement: edge.placement)
        let end = adjustedPoint(for: endNodeCenter, nodeSize: endNodeSize, placement: edge.placement.opposite(basedOn: direction))
        self.adjustedPoints = (start: start, end: end)
    }
    
    
    var body: some View {
        ZStack {
            createPath()
                .stroke(
                    startColor.opacity(0.75),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
                .overlay(edgeLabel)
            
            createNodeMarker(at: adjustedPoints.start, color: startColor)
            createNodeMarker(at: adjustedPoints.end, color: startColor)
        }
    }

    private func createPath() -> Path {
        return Path { path in
            path.move(to:  adjustedPoints.start)
            if startPoint.y != endPoint.y {
                path.addLine(to: firstIntermediatePoint)
                path.addLine(to: secondIntermediatePoint(basedOn: direction))
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
                .frame(width: 10, height: 10)
                .position(point)

            Circle()
                .fill(color.opacity(0.75))
                .frame(width: 4, height: 4)
                .position(point)
        }
        .animation(.default, value: point)
    }

    private var firstIntermediatePoint: CGPoint {
        let xStart = adjustedPoints.start.x
        let yStart = adjustedPoints.start.y
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: xStart + hOffset, y: startNodeCenter.y)
        case .top:
            return CGPoint(x: xStart, y: yStart + vOffset)
        case .topLeading, .topTrailing, .bottomTrailing:
            return CGPoint(x: xStart + hOffset, y: yStart)
        default:
            return CGPoint(x: xStart, y: adjustedPoints.end.y)
        }
    }
    
    private func secondIntermediatePoint(basedOn direction: Direction) -> CGPoint {
        let start = adjustedPoints.start.x
        let end = adjustedPoints.end.y
        switch edge.placement {
        case .trailing, .leading:
            return CGPoint(x: start + hOffset, y:end)
        case .top:
            return CGPoint(x: start + hOffset, y: adjustedPoints.start.y + vOffset)
        case .topLeading, .topTrailing, .bottomTrailing:
            return CGPoint(x: start + hOffset, y: end)
        default:
            return CGPoint(x: start, y: end)
        }
    }
    
    private var thirdIntermediatePoint: CGPoint {
        switch edge.placement {
        case .top:
            return CGPoint(x: adjustedPoints.start.x + horizontalOffset(for: edge.placement), y: adjustedPoints.end.y)
        default: return .zero
        }
    }

    private func horizontalOffset(for placement: EdgePlacement) -> CGFloat {
        switch placement {
        case .trailing: 24
        case .leading: -16
        case .top: -(startNodeSize.width / 2) - 24
        case .topLeading: -24
        case .topTrailing: 16
        case .bottomTrailing: 32
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

enum Direction {
    case up
    case down
    case leftOrRight
}

extension EdgePlacement {
    func opposite(basedOn direction: Direction) -> EdgePlacement {
        switch self {
        case .trailing:
            switch direction {
            case .up: return .bottomLeading
            case .down: return .topLeading
            case .leftOrRight: return .leading
            }
        case .bottomTrailing:
            switch direction {
            case .down: return .topLeading
            default: return .bottomLeading
            }
        default:
            switch direction {
            case .up: return .bottomLeading
            default: return .topLeading
            }
        }
    }
}
