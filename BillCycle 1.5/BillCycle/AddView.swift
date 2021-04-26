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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                TextField("Service Provider", text: $title)
                    .roundedTextField()
                    .disableAutocorrection(true)
                #if os(iOS)
                TextField("It's a fixed payment? (optional)", text: $fixedAmount)
                    .disableAutocorrection(true)
                    .keyboardType(.decimalPad)
                    .roundedTextField()
                
                #else
                TextField("It's a fixed payment? (optional)", text: $fixedAmount)
                    .roundedTextField()
                #endif
                TextEditor(text: $details)
                    .roundedTextEditor()
                    
                Spacer()
            }
            .padding(.vertical)
            .padding(.horizontal, 2)
            .navigationTitle("Add Bill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") { presentationMode.wrappedValue.dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                    let bill = Bill(context: moc)
                    bill.title = title
                    bill.details = details
                    bill.fixedAmount = Double(fixedAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                    bill.status = StatusTypes.unpaid.rawValue
                    
                    PersistenceController.shared.save()
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !fixedAmount.isEmpty && Double(fixedAmount.replacingOccurrences(of: ",", with: ".")) == nil)
                }
            }
            
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
