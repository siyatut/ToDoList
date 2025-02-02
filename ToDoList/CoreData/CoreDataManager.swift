//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import CoreData

final class CoreDataManager {

    // MARK: - Singleton instance

    static let shared = CoreDataManager()

    // MARK: - Init

    private init() {}

    // MARK: - Persistent container

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    // MARK: - Managed object context

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save context

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                print("Failed to save Core Data context: \(error)")
            }
        } else {
            print("No changes to save in context")
        }
    }
}
