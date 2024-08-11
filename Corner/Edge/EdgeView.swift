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
            let startPoint = adjustedPoint(for: from, nodeSize: fromNodeSize, placement: edge.placement)
            let endPoint = adjustedPoint(for: to, nodeSize: toNodeSize, placement: edge.placement.opposite)
            Path { path in
                path.move(to: startPoint)
                if to.y != from.y {
                    switch edge.placement {
                    case .trailing:
                        path.addLine(to: CGPoint(x: startPoint.x + 16, y: startPoint.y))
                        path.addLine(to: CGPoint(x: startPoint.x + 16, y: to.y))
                    case .leading:
                        path.addLine(to: CGPoint(x: startPoint.x - 16, y: startPoint.y))
                        path.addLine(to: CGPoint(x: startPoint.x - 16, y: to.y))
                    case .topLeading:
                        path.addLine(to: CGPoint(x: startPoint.x - 24, y: startPoint.y))
                        path.addLine(to: CGPoint(x: startPoint.x - 24, y: to.y))
                    case .top:
                        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - 16))
                        path.addLine(to: CGPoint(x: startPoint.x - (fromNodeSize.width / 2) - 24, y: startPoint.y - 16))
                        path.addLine(to: CGPoint(x: startPoint.x - (fromNodeSize.width / 2) - 24, y: to.y))
                    default:
                        path.addLine(to: CGPoint(x: startPoint.x, y: to.y))
                    }
                }
                path.addLine(to: endPoint)
            }
            .stroke(
                fromColor.opacity(0.5),
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
        let yPosition = edge.placement == .topTrailing ? (to.y / 2) - 8 : to.y
        return Group {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .padding(8)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
                    .position(x: (from.x + to.x) / 2, y: yPosition)
            }
        }
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
