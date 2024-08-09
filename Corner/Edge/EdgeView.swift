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
    

    var body: some View {
        Path { path in
            let pot = CGPoint(
                x: from.x + placementOffset(for: edge.placement).x,
                y: from.y + placementOffset(for: edge.placement).y
            )
            
            let toPoint = CGPoint(
                x: to.x + toPlacementOffset.x,
                y: to.y + toPlacementOffset.y
            )
            
            if to.y != from.y {
                path.move(to: pot)
                path.addLine(to: CGPoint(x: pot.x, y: to.y))
                path.addLine(to: toPoint)
               
            } else {
                path.move(to: pot)
                path.addLine(to: toPoint)
            }
        }
        .stroke(edge.color.opacity(0.4), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        .overlay {
            if !edge.label.isEmpty {
                Text(edge.label)
                    .padding(8)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
                    .position(x: (from.x + to.x) / 2, y: to.y)
            }
        }
    }
    
    private func placementOffset(for placement: EdgePlacement) -> CGPoint {
        let padding: CGFloat = 16
        let halfWidth = (fromNodeSize.width - padding) / 2
        let halfHeight = (fromNodeSize.height - padding) / 2
        
        switch placement {
        case .topTrailing:
            return CGPoint(x: halfWidth, y: -halfHeight)
        case .trailing:
            return CGPoint(x: halfWidth, y: 0)
        case .bottomTrailing:
            return CGPoint(x: halfWidth - 8, y: halfHeight)
        case .bottom:
            return CGPoint(x: 0, y: halfHeight)
        case .bottomLeading:
            return CGPoint(x: -halfWidth + 8, y: halfHeight)
        case .leading:
            return CGPoint(x: -halfWidth, y: 0)
        case .topLeading:
            return CGPoint(x: -halfWidth, y: -halfHeight)
        case .top:
            return CGPoint(x: 0, y: -halfHeight)
        }
    }
    
    private var toPlacementOffset: CGPoint {
        let padding: CGFloat = 16
        let halfWidth = (toNodeSize.width - padding) / 2
        let halfHeight = (toNodeSize.height - padding) / 2
        
        switch edge.placement {
        case .topTrailing:
            return CGPoint(x: -halfWidth, y: -halfHeight)
        default:
            return CGPoint(x: -halfWidth, y: 0)
        }
    }
}
