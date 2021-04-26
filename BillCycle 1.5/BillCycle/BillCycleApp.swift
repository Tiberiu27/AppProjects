//
//  BillCycleApp.swift
//  BillCycle
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

@main
struct BillCycleApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistanceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistanceController.save()
        }
    }
}
