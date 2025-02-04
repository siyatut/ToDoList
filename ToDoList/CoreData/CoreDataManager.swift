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

    // MARK: - Core Data Stack

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

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

    // MARK: - Task Management

    func saveTask(_ task: Task) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.descriptionText = task.description
        taskEntity.dateCreated = task.dateCreated
        taskEntity.isCompleted = task.isCompleted
        saveContext()
    }

    func updateTask(_ task: Task) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)

        do {
            if let taskEntity = try context.fetch(fetchRequest).first {
                taskEntity.title = task.title
                taskEntity.descriptionText = task.description
                taskEntity.isCompleted = task.isCompleted
                saveContext()
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
}
