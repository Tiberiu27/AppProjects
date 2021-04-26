//
//  RowView.swift
//  MacBillCycle
//
//  Created by Tiberiu on 06.04.2021.
//

import SwiftUI

struct RowView: View {
    @ObservedObject var bill: Bill
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(bill.title ?? "Unkown title")")
                    .font(.title)
                
                if bill.fixedAmount != 0.0 {
                    Text("$\(bill.fixedAmount, specifier: "%g")").labelsHidden()
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(bill.status ?? "Unpaid")
                    .font(.title2)
                    .foregroundColor(bill.status == StatusTypes.unpaid.rawValue ? Color.red : Color.green)
                
                if bill.status == StatusTypes.paid.rawValue {
                    Text("\(bill.paidDate ?? Date(), style: .date)")
                }
            }
        }
        .frame(maxHeight: 50)
    }
}

