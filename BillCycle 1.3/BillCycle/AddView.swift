//
//  AddView.swift
//  BillCycle
//
//  Created by Tiberiu on 21.02.2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var details = "Description (optional)"
    @State private var fixedAmount = ""
    @State private var showingAlert = false
    
    static let statusTypes = ["Unpaid", "Paid"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Service Provider", text: $title)
                    .disableAutocorrection(true)
                
                TextField("It's a fixed payment? (optional)", text: $fixedAmount)
                    .keyboardType(.decimalPad)
                    
                TextEditor(text: $details)
                    .frame(height: 100, alignment: .topLeading)
                    .disableAutocorrection(true)
                    
                
            }
            .navigationBarTitle("Add Bill", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                let bill = Bill(context: moc)
                bill.title = title
                bill.details = details
                bill.fixedAmount = Double(fixedAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                bill.status = AddView.statusTypes[0]
                
                PersistenceController.shared.save()
                
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !fixedAmount.isEmpty && Double(fixedAmount.replacingOccurrences(of: ",", with: ".")) == nil)
            )
            
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Some title"), message: Text("some message"), dismissButton: .default(Text("Bye")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
