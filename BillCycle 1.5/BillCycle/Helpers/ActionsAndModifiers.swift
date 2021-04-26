//
//  Actions.swift
//  BillCycle
//
//  Created by Tiberiu on 03.04.2021.
//

import Foundation
import SwiftUI

enum StatusTypes: String {
    case unpaid = "Unpaid"
    case paid = "Paid"
}

func changeStatus(_ bill: Bill) {
    if bill.status == StatusTypes.unpaid.rawValue {
        bill.status = StatusTypes.paid.rawValue
        bill.paidDate = Date()
    } else  if bill.status == StatusTypes.paid.rawValue {
        bill.status = StatusTypes.unpaid.rawValue
        bill.paidDate = nil
    }
    
    haptic()
    
    PersistenceController.shared.save()
}

func haptic() {
    #if os(iOS)
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
    #elseif os(watchOS)
    WKInterfaceDevice.current().play(.click)
    #endif
}


struct RoundedTextEditor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 100)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.secondary)
            )
    }
}

struct RoundedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 25)
            .padding(2)
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.secondary)
            )
    }
}


extension View {
    func roundedTextEditor() -> some View {
        self.modifier(RoundedTextEditor())
    }
    
    func roundedTextField() -> some View {
        self.modifier(RoundedTextField())
    }
}

#if os(macOS)
//so the textEditor has a clear background
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
#endif

