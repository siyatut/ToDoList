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
        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)

            do {
                let existingTaskEntities = try self.context.fetch(fetchRequest)

                if let existingTaskEntity = existingTaskEntities.first {
                    existingTaskEntity.title = task.title
                    existingTaskEntity.descriptionText = task.description
                    existingTaskEntity.dateCreated = task.dateCreated
                    existingTaskEntity.isCompleted = task.isCompleted
                } else {
                    let newTaskEntity = TaskEntity(context: self.context)
                    newTaskEntity.id = task.id
                    newTaskEntity.title = task.title
                    newTaskEntity.descriptionText = task.description
                    newTaskEntity.dateCreated = task.dateCreated
                    newTaskEntity.isCompleted = task.isCompleted
                }

                self.saveContext()
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
        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

            do {
                let taskEntities = try self.context.fetch(fetchRequest)
                let tasks = taskEntities.map { taskEntity in
                    Task(
                        id: taskEntity.id ?? "",
                        title: taskEntity.title ?? "",
                        description: taskEntity.descriptionText ?? "",
                        dateCreated: taskEntity.dateCreated ?? "",
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
        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)

            do {
                let taskEntities = try self.context.fetch(fetchRequest)
                if let taskEntity = taskEntities.first {
                    self.context.delete(taskEntity)
                    self.saveContext()
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
