//
//  PersistenceController.swift
//  TestToDoList
//
//  Created by Иван Марин on 19.10.2023.
//

import CoreData

/// A struct for managing the Core Data stack, including the managed object context,
/// persistent container, and persistent store.
struct PersistenceController {
    static let shared = PersistenceController()  /// Shared instance of the PersistenceController.

    let container: NSPersistentContainer  /// The persistent container for Core Data.

    /// Initializer for setting up the Core Data stack.
    /// - Parameter inMemory: A Boolean value indicating whether the Core Data stack
    /// should operate in memory. Defaults to `false`.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskEntity")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
