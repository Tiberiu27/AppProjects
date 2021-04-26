//
//  ContentView.swift
//  WatchBillCycle Extension
//
//  Created by Tiberiu on 31.03.2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        BillList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
