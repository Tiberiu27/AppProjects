//
//  ChangeStatusButton.swift
//  BillCycle
//
//  Created by Tiberiu on 10.04.2021.
//

import SwiftUI

struct ChangeStatusButton: View {
    @ObservedObject var bill: Bill
    var body: some View {
        Button(action: {
            changeStatus(bill)
        }) {
            Text("Mark as \(bill.status == StatusTypes.unpaid.rawValue ? "Paid" : "Unpaid")")
                .font(.title2)
                .frame(
                    width: 170,
                    height: 70
                )
                .background(bill.status == StatusTypes.unpaid.rawValue ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.2), radius: 10, x: -5, y: -5)
                
        }
        .buttonStyle(PlainButtonStyle())
    }
}
