//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit
import CoreData

protocol TaskUpdating {
    func updateTask(_ task: Task)
}

final class TaskListInteractor: TaskListInteractorProtocol, TaskUpdating {

    // MARK: - Dependencies

    private let networkManager: NetworkManagerProtocol
    private var cachedTasks: [Task] = []
    private let urlString = "https://dummyjson.com/todos"

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    // MARK: - Fetch tasks

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        let cachedTasks = fetchTasksFromCoreData()
        if !cachedTasks.isEmpty {
            print("Using cached tasks from Core Data")
            self.cachedTasks = cachedTasks
            completion(cachedTasks)
        } else {
            print("Core Data is empty, fetching tasks from URL")
            DispatchQueue.global(qos: .background).async {
                self.networkManager.fetchTasks(from: self.urlString) { result in
                    switch result {
                    case .success(let temporaryTasks):
                        let tasks = temporaryTasks.map(TaskMapper.map)
                        self.cachedTasks = tasks
                        self.saveTasksToCoreData(tasks: tasks)
                        DispatchQueue.main.async {
                            completion(tasks)
                        }
                    case .failure(let error):
                        print("Failed to fetch tasks: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion([])
                        }
                    }
                }
            }
        }
    }

    // MARK: - Update task

    func updateTask(_ task: Task) {
        let context = CoreDataManager.shared.context
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)

            do {
                if let existingTask = try context.fetch(fetchRequest).first {
                    existingTask.isCompleted = task.isCompleted
                    try context.save()
                    print("Task updated in Core Data: \(task.title) - \(task.isCompleted)")

                    DispatchQueue.main.async {
                        self.cachedTasks = self.fetchTasksFromCoreData()
                    }
                } else {
                    print("Task not found in Core Data: \(task.title)")
                }
            } catch {
                print("Failed to update task in Core Data: \(error)")
            }
        }

        if let index = self.cachedTasks.firstIndex(where: { $0.id == task.id }) {
            self.cachedTasks[index] = task
        }
    }
    
    // MARK: - Fetch tasks from Core Data

    private func fetchTasksFromCoreData() -> [Task] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { taskEntity in
                Task(
                    id: Int(taskEntity.id),
                    title: taskEntity.title ?? "",
                    description: taskEntity.descriptionText ?? "",
                    dateCreated: taskEntity.dateCreated ?? "",
                    isCompleted: taskEntity.isCompleted
                )
            }
        } catch {
            print("Failed to fetch tasks from Core Data: \(error)")
            return []
        }
    }
    
    // MARK: - Save tasks to Core Data

    private func saveTasksToCoreData(tasks: [Task]) {
        let context = CoreDataManager.shared.context
        context.perform {
            tasks.forEach { task in
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)

                do {
                    if let existingTask = try context.fetch(fetchRequest).first {
                        existingTask.title = task.title
                        existingTask.descriptionText = task.description
                        existingTask.dateCreated = task.dateCreated
                        existingTask.isCompleted = task.isCompleted
                    } else {
                        let taskEntity = TaskEntity(context: context)
                        taskEntity.id = Int64(task.id)
                        taskEntity.title = task.title
                        taskEntity.descriptionText = task.description
                        taskEntity.dateCreated = task.dateCreated
                        taskEntity.isCompleted = task.isCompleted
                    }
                } catch {
                    print("Failed to fetch task for updating: \(error)")
                }
            }

            do {
                try context.save()
                print("Tasks saved to Core Data")
            } catch {
                print("Failed to save tasks to Core Data: \(error)")
            }
        }
    }

    // MARK: - Delete task from Core Data

    func deleteTask(_ task: Task) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let taskEntity = results.first {
                context.delete(taskEntity)
                CoreDataManager.shared.saveContext()
                print("Task deleted from Core Data: \(task.title)")
            }
        } catch {
            print("Failed to delete task from Core Data: \(error.localizedDescription)")
        }
    }
}
