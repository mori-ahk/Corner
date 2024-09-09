//
//  InputTextView.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-11.
//

import Foundation
import SwiftUI

struct InputTextView: NSViewRepresentable {
    @Binding var text: String
    var textColor: NSColor
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: InputTextView
        var isTextViewUpdating = false
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard !isTextViewUpdating else { return }
            if let textView = notification.object as? NSTextView {
                if textView.string != self.parent.text {
                    self.parent.text = textView.string
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.verticalScroller?.controlSize = .mini
        scrollView.borderType = .noBorder
        scrollView.autoresizingMask = [.width, .height]
        scrollView.wantsLayer = true
        scrollView.layer?.cornerRadius = 12
        scrollView.layer?.masksToBounds = true

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isSelectable = true
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.autoresizingMask = [.width]
        textView.textContainerInset = NSSize(width: 12, height: 12)
        textView.textContainer?.widthTracksTextView = true
        textView.wantsLayer = true
        textView.layer?.cornerRadius = 12
        textView.layer?.masksToBounds = true
        textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.backgroundColor = NSColor.gray.withAlphaComponent(0.1)
        textView.textColor = textColor
        textView.string = text
        
        
        scrollView.documentView = textView
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.string != text {
            context.coordinator.isTextViewUpdating = true
            let selectedRange = textView.selectedRange()
            textView.textColor = textColor
            textView.string = text
            textView.setSelectedRange(selectedRange)
            context.coordinator.isTextViewUpdating = false
        }
    }
}
