//
//  ErrorView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundStyle(.red)
            Text("An error has occured when parsing the input.")
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
        }
    }
}
