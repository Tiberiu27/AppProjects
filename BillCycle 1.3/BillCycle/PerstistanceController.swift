//
//  PerstistanceController.swift
//  BillCycle
//
//  Created by Tiberiu on 21.02.2021.
//

import CoreData


struct PersistenceController {
    //A singleton for our entire app to use
    static let shared = PersistenceController()
    
    
    //Storage for Core Data
    let container: NSPersistentContainer
    
    //A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        for _ in 0 ..< 10 {
            let bill = Bill(context: controller.container.viewContext)
            bill.title = "Service provider 1"
            bill.status = "Paid"
        }
        
        return controller
    }()
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //Show some error code
            }
        }
    }
    
    //An initializer to load Core Data, optionally able to use in-memory store.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { descirption, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
