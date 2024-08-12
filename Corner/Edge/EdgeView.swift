//
//  EdgeView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-06.
//

import SwiftUI

struct EdgeView: View {
    let edge: Edge
    let from: CGPoint
    let to: CGPoint
    let fromNodeSize: CGSize
    let toNodeSize: CGSize
    let fromColor: Color
    let toColor: Color

    var body: some View {
        ZStack {
            let startPoint = adjustedPoint(for: fromCenter, nodeSize: fromNodeSize, placement: edge.placement)
            let endPoint = adjustedPoint(for: toCenter, nodeSize: toNodeSize, placement: edge.placement.opposite)
            Path { path in
                path.move(to: startPoint)
                if to.y != from.y {
                    switch edge.placement {
                    case .trailing:
                        path.addLine(to: CGPoint(x: startPoint.x + 16, y: fromCenter.y))
                        path.addLine(to: CGPoint(x: startPoint.x + 16, y: toCenter.y))
                    case .leading:
                        path.addLine(to: CGPoint(x: startPoint.x - 16, y: fromCenter.y))
                        path.addLine(to: CGPoint(x: startPoint.x - 16, y: toCenter.y))
                    case .topLeading:
                        path.addLine(to: CGPoint(x: startPoint.x - 24, y: fromCenter.y))
                        path.addLine(to: CGPoint(x: startPoint.x - 24, y: toCenter.y))
                    case .top:
                        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - 16))
                        path.addLine(to: CGPoint(x: startPoint.x - (fromNodeSize.width / 2) - 24, y: startPoint.y - 16))
                        path.addLine(to: CGPoint(x: startPoint.x - (fromNodeSize.width / 2) - 24, y: toCenter.y))
                    default:
                        path.addLine(to: CGPoint(x: startPoint.x, y: toCenter.y))
                    }
                }
                path.addLine(to: endPoint)
            }
            .stroke(
                fromColor.opacity(0.75),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .overlay(edgeLabel)

            ZStack {
                Circle()
                    .fill(fromColor.opacity(0.1))
                    .frame(width: 12, height: 12)
                    .position(startPoint)
                
                Circle()
                    .fill(fromColor.opacity(0.75))
                    .frame(width: 6, height: 6)
                    .position(startPoint)

            }
            
            ZStack {
                Circle()
                    .fill(toColor.opacity(0.1))
                    .frame(width: 12, height: 12)
                    .position(endPoint)
                
                Circle()
                    .fill(toColor.opacity(0.75))
                    .frame(width: 6, height: 6)
                    .position(endPoint)

            }
        }
    }

    private func adjustedPoint(for point: CGPoint, nodeSize: CGSize, placement: EdgePlacement) -> CGPoint {
        let padding: CGFloat = 16
        let halfWidth = (nodeSize.width - padding) / 2
        let halfHeight = (nodeSize.height - padding) / 2

        let offset: CGPoint
        switch placement {
        case .topTrailing:
            offset = CGPoint(x: halfWidth, y: -halfHeight)
        case .trailing:
            offset = CGPoint(x: halfWidth, y: 0)
        case .bottomTrailing:
            offset = CGPoint(x: halfWidth, y: halfHeight)
        case .bottom:
            offset = CGPoint(x: 0, y: halfHeight + 2)
        case .bottomLeading:
            offset = CGPoint(x: -halfWidth, y: halfHeight)
        case .leading:
            offset = CGPoint(x: -halfWidth, y: 0)
        case .topLeading:
            offset = CGPoint(x: -halfWidth, y: -halfHeight)
        case .top:
            offset = CGPoint(x: 0, y: -halfHeight)
        }

        return CGPoint(x: point.x + offset.x, y: point.y + offset.y)
    }

    private var edgeLabel: some View {
        let yPosition = edge.placement == .topTrailing ? (toCenter.y / 2) - 20 : toCenter.y
        return Group {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .padding(UXMetrics.Padding.eight)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.eight))
                    .shadow(radius: UXMetrics.ShadowRadius.four)
                    .position(x: (fromCenter.x + toCenter.x) / 2, y: yPosition)
            }
        }
    }
    
    private var fromCenter: CGPoint {
        CGPoint(x: from.x + fromNodeSize.width / 2, y: from.y + fromNodeSize.height / 2)
    }
    
    private var toCenter: CGPoint {
        CGPoint(x: to.x + toNodeSize.width / 2, y: to.y + toNodeSize.height / 2)
    }
}

extension EdgePlacement {
    var opposite: EdgePlacement {
        switch self {
        case .topTrailing: return .topLeading
        default : return .leading
        }
    }
}
