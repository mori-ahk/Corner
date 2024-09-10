//
//  DiagramState.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import Foundation
import CornerParser

enum DiagramState: Equatable {
    case idle
    case loading
    case loaded
    case failed(ParseError?)
}
