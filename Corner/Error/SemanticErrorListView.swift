//
//  SemanticErrorListView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import SwiftUI
import CornerParser

struct SemanticErrorListView: View {
    let errors: [SemanticError]
    var body: some View {
        VStack {
            ForEach(errors, id: \.description) { error in
                ErrorListItemView(errorDescription: error.description)
            }
        }
    }
}
