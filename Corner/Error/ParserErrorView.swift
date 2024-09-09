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
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(.red)
            
            Text(error.description)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.twelve)
                .fill(.red.opacity(0.1))
                .shadow(radius: UXMetrics.ShadowRadius.four)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
