//
//  CornerApp.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-04.
//

import SwiftUI

@main
struct CornerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(nodes: [
                Node(id: "ImageRepo", color: .blue),
                Node(id: "ImageCache", color: .green),
            ])
            .fontDesign(.monospaced)
        }
    }
}
