//
//  SemanticResultListView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import SwiftUI
import CornerParser

struct SemanticResultListView: View {
    let result: SemanticAnalysisResult
    
    var body: some View {
        VStack {
            ForEach(result.errors, id: \.description) { error in
                SemanticResultListItemView(errorDescription: error.description)
            }
            
            ForEach(result.warnings, id: \.description) { error in
                SemanticResultListItemView(errorDescription: error.description, isWarning: true)
            }
        }
    }
}
