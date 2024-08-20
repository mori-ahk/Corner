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
}

extension EdgeAnchorPlacement {
    func opposite(basedOn direction: EdgeDirection) -> EdgeAnchorPlacement {
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
