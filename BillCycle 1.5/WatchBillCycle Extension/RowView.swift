//
//  RowView.swift
//  WatchBillCycle Extension
//
//  Created by Tiberiu on 31.03.2021.
//

import SwiftUI
import CoreData

struct RowView: View {
    @ObservedObject var bill: Bill
    @State private var blurred = false
    
    var body: some View {
        HStack {
            Text(bill.title ?? "Unknown title")
            Spacer()
            Text(bill.status ?? "Unknown status")
                .foregroundColor(bill.status == "Unpaid" ? Color.red : Color.green)
        }
        .blur(radius: blurred ? 5.0 : 0.0)
        .onLongPressGesture(minimumDuration: 1, pressing: { inProgress in
            blurred = inProgress
        }) {
            withAnimation {
                changeStatus(bill)
            }
        }
        
    }
}

struct RowView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let bill = Bill(context: moc)
        RowView(bill: bill)
    }
}
