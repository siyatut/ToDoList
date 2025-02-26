//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import CoreData

final class CoreDataManager: CoreDataManagerProtocol {

    // MARK: - Singleton instance

    static let shared = CoreDataManager()

    // MARK: - Init

    init() {}

    // MARK: - Core Data Stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    private var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context

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

    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)

            do {
                let existingTaskEntities = try backgroundContext.fetch(fetchRequest)
                if let existingTaskEntity = existingTaskEntities.first {
                    existingTaskEntity.title = task.title
                    existingTaskEntity.descriptionText = task.description
                    existingTaskEntity.dateCreated = task.dateCreated
                    existingTaskEntity.isCompleted = task.isCompleted
                    existingTaskEntity.dateUpdated = DateHelper.formattedDate(from: Date())
                } else {
                    let newTaskEntity = TaskEntity(context: backgroundContext)
                    newTaskEntity.id = task.id
                    newTaskEntity.title = task.title
                    newTaskEntity.descriptionText = task.description
                    newTaskEntity.dateCreated = task.dateCreated
                    newTaskEntity.dateUpdated = nil
                    newTaskEntity.isCompleted = task.isCompleted
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
                print("Failed to fetch or save task: \(error)")
            }
        }
    }

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

            do {
                let taskEntities = try backgroundContext.fetch(fetchRequest)
                let tasks = taskEntities.map { taskEntity in
                    Task(
                        id: taskEntity.id ?? "",
                        title: taskEntity.title ?? "",
                        description: taskEntity.descriptionText ?? "",
                        dateCreated: taskEntity.dateCreated ?? "",
                        dateUpdated: taskEntity.dateUpdated,
                        isCompleted: taskEntity.isCompleted
                    )
                }

                DispatchQueue.main.async {
                    completion(tasks)
                }

            } catch {
                print("Failed to fetch tasks from Core Data: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }

    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)

            do {
                let taskEntities = try backgroundContext.fetch(fetchRequest)
                if let taskEntity = taskEntities.first {
                    backgroundContext.delete(taskEntity)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                    print("Task deleted: \(task.title)")
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("Failed to delete task: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
