//
//  DetailView.swift
//  MacBillCycle
//
//  Created by Tiberiu on 06.04.2021.
//

import SwiftUI


struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var bill: Bill
    
    @State private var details = "Description (optional)"
    
    var body: some View {
        VStack {
            TextEditor(text: $details)
                .onChange(of: details, perform: { value in
                    bill.details = details
                    PersistenceController.shared.save()
                })
                .roundedTextEditor()
            
            Divider()
            
            ChangeStatusButton(bill: bill)
            
            Spacer()
        }
        .padding()
        .navigationTitle(bill.title ?? "My Bill")
        
        .toolbar {
            ToolbarItem {
                Button(action: {
                    moc.delete(bill)
                    PersistenceController.shared.save()
                }) {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    init(bill: Bill) {
        self.bill = bill
        self._details = State<String>(initialValue: bill.details ?? "Description(optional)")
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let bill = Bill(context: moc)
        bill.title = "Some title"
        bill.details = "Description (Optional)"
        
        return NavigationView {
            DetailView(bill: bill)
        }
    }}


