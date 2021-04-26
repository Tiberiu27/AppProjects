//
//  BillList.swift
//  WatchBillCycle Extension
//
//  Created by Tiberiu on 31.03.2021.
//

import SwiftUI

struct BillList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Bill.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Bill.status, ascending: false),
    ])
    var bills: FetchedResults<Bill>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bills, id: \.self) { bill in
                    NavigationLink(destination: Text("Placeholder detailView")) {
                        RowView(bill: bill)
                    }
                }
                .onDelete(perform: removeBill)
            }
        }
        .onAppear(perform: test)
    }
    
    func removeBill(at offsets: IndexSet) {
        for index in offsets {
            let bill = bills[index]
            moc.delete(bill)
        }
        
        PersistenceController.shared.save()
    }
    
    func test() {
        let bill = Bill(context: moc)
        bill.title = "Gym"
        bill.status = "Paid"
        let bill2 = Bill(context: moc)
        bill2.title = "Electricity"
        bill2.status = "Unpaid"
        let bill3 = Bill(context: moc)
        bill3.title = "Water"
        bill3.status = "Paid"
        let bill4 = Bill(context: moc)
        bill4.title = "Internet"
        bill4.status = "Paid"
        let bill5 = Bill(context: moc)
        bill5.title = "Internet Inlaws"
        bill5.status = "Paid"
        PersistenceController.shared.save()
    }
}

struct BillList_Previews: PreviewProvider {
    
    static var previews: some View {
        BillList()
    }
}
