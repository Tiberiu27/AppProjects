//
//  RowView.swift
//  BillCycle
//
//  Created by Tiberiu on 11.03.2021.
//

import SwiftUI

struct RowView: View {
    let bill: Bill
    @State private var blurred = false
    
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
                    .foregroundColor(bill.status == AddView.statusTypes[0] ? Color.red : Color.green)
                    .onTapGesture {} //needed so you can swipe to delete from this section also
                    .onLongPressGesture(minimumDuration: 1, pressing: { inProgress in
                        blurred = inProgress
                    }) {
                        withAnimation {
                            changeStatus(bill)
                        }
                    }
                
                if bill.status == AddView.statusTypes[1] {
                    Text("\(bill.paidDate ?? Date(), style: .date)").labelsHidden()
                }
            }
            .blur(radius: blurred ? 5: 0)
        }
    }
    
    func changeStatus(_ bill: Bill) {
        if bill.status == AddView.statusTypes[0] {
            bill.status = AddView.statusTypes[1]
            bill.paidDate = Date()
        } else  if bill.status == AddView.statusTypes[1] {
            bill.status = AddView.statusTypes[0]
            bill.paidDate = nil
        }
        
        simpleSuccess()
        
        PersistenceController.shared.save()
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

}

