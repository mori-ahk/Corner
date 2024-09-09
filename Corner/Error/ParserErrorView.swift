//
//  ParserErrorView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import SwiftUI
import CornerParser

struct ParserErrorView: View {
    let error: ParseError
    
    var body: some View {
        Text(error.description)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding()
            .background(.red.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve))
            .shadow(radius: UXMetrics.ShadowRadius.four)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
