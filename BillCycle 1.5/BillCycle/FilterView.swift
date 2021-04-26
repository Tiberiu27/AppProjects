//
//  FilterView.swift
//  BillCycle
//
//  Created by Tiberiu on 25.02.2021.
//

import SwiftUI


struct FilterView: View {
    var fetchRequest: FetchRequest<Bill>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var settings: Settings
    var bills: FetchedResults<Bill> { fetchRequest.wrappedValue }
    
    @State private var showingAddView = false
    @Binding var filterNum: Int
    var filterButtonName: String
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(bills, id: \.self) { bill in
                    NavigationLink(destination: DetailView(bill: bill)) {
                        RowView(bill: bill)
                    }
                }
                .onDelete(perform: removeBill)
            }
            .onAppear(perform: checkDate)
            
            .navigationBarTitle("BillCycle")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Show \(filterButtonName)") { changeFilter() }
                        Button(" \(settings.isEnabled ? "Disable" : "Enable") authentication") { biometricAuthentication() }
                        Button("Cancel") {}
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            //placeholder for iPad in landscape mode if no bill is selected
            Text("Select a bill")
        }
        .sheet(isPresented: $showingAddView) {
            AddView()
        }
    }
    
    func removeBill(at offsets: IndexSet) {
        for index in offsets {
            let bill = bills[index]
            moc.delete(bill)
        }
        
        PersistenceController.shared.save()
    }
    
    func changeFilter() {
        filterNum += 1
        if filterNum > 3 {
            filterNum = 1
        }
        saveSelection()
    }
        
    func checkDate() {
        migrateFromUserDefaults()
        loadSelection()
        let now  = Date()
        
        for bill in bills {
            let dateComparison = Calendar.current.compare(now, to: bill.paidDate ?? Date(), toGranularity: .month)
            
            if dateComparison == .orderedDescending {
                bill.status = StatusTypes.unpaid.rawValue
                bill.paidDate = nil
            }
        }
        
        PersistenceController.shared.save()
    }
    
    
    func migrateFromUserDefaults() {
        if let items = UserDefaults.standard.data(forKey: "Bills") {
            let decoder = JSONDecoder()
            if let decodedStructs = try? decoder.decode([BillStruct].self, from: items) {
                for billStruct in decodedStructs {
                    let bill = Bill(context: moc)
                    bill.id = billStruct.id
                    bill.title = billStruct.title
                    bill.status = billStruct.status
                    bill.details = billStruct.description
                    bill.paidDate = billStruct.paidDate
                }
                PersistenceController.shared.save()
                UserDefaults.standard.removeObject(forKey: "Bills")
                return
            }
        }
    }
    
    func biometricAuthentication() {
        settings.isEnabled.toggle()
    }
    
    func saveSelection() {
        let encoder = JSONEncoder()
        if let encodedSelection = try? encoder.encode(filterNum) {
            UserDefaults.standard.set(encodedSelection, forKey: "filterNum")
        } else {
            print("Unable to save data.")
        }
    }
    
    func loadSelection() {
        if let filterNum = UserDefaults.standard.data(forKey: "filterNum") {
            let decoder = JSONDecoder()
            if let decodedSelection = try? decoder.decode(Int.self, from: filterNum) {
                self.filterNum = decodedSelection
                return
            } else {
                print("Unable to load data.")
            }
        }        
    }
    

    
    init(predicate: NSPredicate, filterNum: Binding<Int>, filterButtonName: String) {
        fetchRequest = FetchRequest<Bill>(entity: Bill.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Bill.status, ascending: false),
            NSSortDescriptor(keyPath: \Bill.title, ascending: true)
        ], predicate: predicate)
        self._filterNum = filterNum
        self.filterButtonName = filterButtonName
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(predicate: NSPredicate(format: "status == %@", "Paid"), filterNum: .constant(1), filterButtonName: "None")
            .environmentObject(Settings())
    }
}
