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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var details = "Description (optional)"
    @State private var status = ""
    @State private var now = Date()
    @State private var fixedAmount: Double = 0.0
    
    @State private var showingSheet = false
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
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.secondary)
                    )
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

            
            Button("Mark as \(bill.status == AddView.statusTypes[0] ? "Paid" : "Unpaid")") {
                changeStatus()
            }
            .font(.title2)
            .frame(width: 170, height: 80)
            .background(bill.status == AddView.statusTypes[0] ? Color.green : Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.top, 100)
            
            Spacer()
            
        }
        .padding([.horizontal, .vertical])
        
        .toolbar {
            Button(action: {
                showingSheet = true
            }) {
                Image(systemName: "ellipsis.circle")
            }
        }
        
        .onDisappear(perform: {
            bill.details = details
            PersistenceController.shared.save()
        })
        .navigationBarTitle("\(bill.title ?? "Unknown title")", displayMode: .inline)
        
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Customize"), buttons: [
                .default(Text(" \(showingDescription ? "Hide" : "Show")  description")) { showingDescription.toggle() },
                .default(Text("\(bill.fixedAmount == 0.0 ? "Mark as fixed payment" : "Change sum")")) {
                    showingInput = true
                },
                .cancel()
            
            ])
        }

    }
    
    func changeStatus() {
        if bill.status == AddView.statusTypes[0] {
            status = AddView.statusTypes[1]
            bill.paidDate = now
            
        } else if bill.status == AddView.statusTypes[1] {
            status = AddView.statusTypes[0]
            bill.paidDate = nil
        }
        
        bill.status = status
        PersistenceController.shared.save()
        
        presentationMode.wrappedValue.dismiss()
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
