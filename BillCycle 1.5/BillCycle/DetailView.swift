//
//  DetailView.swift
//  BillCycle
//
//  Created by Tiberiu on 21.02.2021.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var details = "Description (optional)"
    @State private var status = ""
    @State private var now = Date()
    @State private var fixedAmount: Double = 0.0
    
    @State private var showingDescription = false
    @State private var showingInput = false
    
    @State private var amountInput = ""
    
    @ObservedObject var bill: Bill
    var body: some View {
        VStack {
            if bill.fixedAmount != 0.0 {
                Text("You pay $\(bill.fixedAmount, specifier: "%g") for this every month").labelsHidden()
                    .padding()
            }
            
            if showingDescription {
                TextEditor(text: $details).labelsHidden()
                    .roundedTextEditor()
                    .contextMenu {
                        Button(action: {
                            showingDescription = false
                        }) {
                            Text("Hide")
                        }
                    }
            }
            
            if showingInput {
                VStack {
                    HStack {
                        TextField("Enter the amount", text: $amountInput)
                            .keyboardType(.decimalPad)
                        
                        Button("Done") {
                            if amountInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                bill.fixedAmount = 0.0
                            } else {
                                bill.fixedAmount = Double(amountInput.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                            }
                            
                            PersistenceController.shared.save()
                            
                            showingInput = false
                        }

                        .disabled(!amountInput.isEmpty && Double(amountInput.replacingOccurrences(of: ",", with: ".")) == nil)
                    
                    }
                    .padding()
                    
                    Text("Leave blank and hit Done if you want to mark it as unfixed payment")
                        .foregroundColor(.red)
                }
                .labelsHidden()
            }

            ChangeStatusButton(bill: bill)
            
            Spacer()
        }
        .padding([.horizontal, .vertical])
        
        .toolbar {
            Menu {
                Button("\(showingDescription ? "Hide" : "Show") description") { showingDescription.toggle() }
                Button("\(bill.fixedAmount == 0.0 ? "Mark as fixed payment" : "Change sum")") { showingInput = true }
                Button("Cancel") {}
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            
        }
        
        .onDisappear(perform: {
            bill.details = details
            PersistenceController.shared.save()
        })
        .navigationBarTitle("\(bill.title ?? "Unknown title")", displayMode: .inline)
        
    }
    
    init(bill: Bill) {
        self.bill = bill
        self._details = State<String>(initialValue: bill.details ?? "Description (optional)")
        self._status = State<String>(initialValue: bill.status ?? "Unpaid")
        self._now = State<Date>(initialValue: bill.paidDate ?? Date())
        self._fixedAmount = State<Double>(initialValue: bill.fixedAmount)
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
    }
}
