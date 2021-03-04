//
//  ContentView.swift
//  BillCycle
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(entity: Bill.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Bill.status, ascending: false),
    ])
    var bills: FetchedResults<Bill>
    
    var predicate: NSPredicate {
        switch filterNum {
        case 1:
            return NSPredicate(format: "status == %@", "Paid")
        case 2:
            return NSPredicate(format: "status == %@", "Unpaid")
        default:
            return NSPredicate(format: "status CONTAINS[c] %@", "pai")
        }
    }
    
    var filterButtonName: String {
        switch filterNum {
        case 1:
            return "Paid"
        case 2:
            return "Unpaid"
        default:
            return "All"
        }
    }
    
    @State private var filterNum = 1
    
    
    var body: some View {
        FilterView(predicate: predicate, filterNum: $filterNum, filterButtonName: filterButtonName)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
