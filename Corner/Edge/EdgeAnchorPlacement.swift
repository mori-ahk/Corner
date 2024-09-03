//
//  EdgeAnchorPlacement.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import Foundation

enum EdgeAnchorPlacement: CaseIterable {
    case topTrailing
    case trailing
    case bottomTrailing
    case bottom
    case bottomLeading
    case leading
    case topLeading
    case top
    
    func horizontalOffset(_ nodeSize: CGSize? = nil) -> CGFloat {
        switch self {
        case .trailing: 16
        case .leading: -16
        case .top: -(nodeSize?.width ?? .zero / 2) - 24
        case .topLeading: -24
        case .bottom: -16
        case .topTrailing, .bottomTrailing: 16
        default: .zero
        }
    }
    
    var verticalOffset: CGFloat {
        switch self {
        case .top: -16
        case .bottom: 16
        default: .zero
        }
    }
}

extension EdgeAnchorPlacement {
    func opposite(
        basedOn direction: FlowDirection,
        _ hasCrossOver: Bool
    ) -> EdgeAnchorPlacement? {
        switch direction {
        case .east: return .leading
        case .west: return .trailing
        case .north: return hasCrossOver ? .bottomTrailing : .bottom
        case .south: return hasCrossOver ? .topTrailing : .top
        case .northeast: return .bottomLeading
        case .northwest: return .bottomTrailing
        case .southeast: return .topLeading
        case .southwest: return .topTrailing
        default: return nil
        }
    }
}
