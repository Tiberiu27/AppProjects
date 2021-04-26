//
//  ContentView.swift
//  MacBillCycle
//
//  Created by Tiberiu on 31.03.2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Bill.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Bill.status, ascending: false),
    ])
    var bills: FetchedResults<Bill>
    
    var filteredBills: [Bill] {
        return bills.filter( {searchText.isEmpty ? true : $0.title!.lowercased().starts(with: searchText.lowercased())} )
    }
    
    @State private var showingAddView = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List(filteredBills, id: \.self) { bill in
                    NavigationLink(destination: DetailView(bill: bill)) {
                       RowView(bill: bill)
                    }
                }
                .frame(minWidth: 300)
            }
            
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            
            Text("Select a bill")
        }
        .navigationTitle("BillCycle")
        
        .sheet(isPresented: $showingAddView) {
            AddView()
                .frame(width: 300, height: 300)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
