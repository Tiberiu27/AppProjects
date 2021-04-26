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
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //Show some error code
                print(error.localizedDescription)
            }
        }
    }
    //An initializer to load Core Data, optionally able to use in-memory store.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { descirption, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
