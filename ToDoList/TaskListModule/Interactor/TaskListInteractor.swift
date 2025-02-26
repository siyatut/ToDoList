//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit
import CoreData

final class TaskListInteractor: TaskListInteractorProtocol {

    // MARK: - Dependencies

    private let storage: CoreDataManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private var cachedTasks: [Task] = []
    private let urlString = "https://dummyjson.com/todos"

    // MARK: - Init

    init(
        storage: CoreDataManagerProtocol = CoreDataManager.shared,
        networkManager: NetworkManagerProtocol = NetworkManager()
    ) {
        self.storage = storage
        self.networkManager = networkManager
    }

    // MARK: - Fetch tasks

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        fetchTasksFromCoreData { cachedTasks in
            if !cachedTasks.isEmpty {
                print("Using cached tasks from Core Data")
                self.cachedTasks = cachedTasks
                completion(cachedTasks)
            } else {
                print("Core Data is empty, fetching tasks from URL")
                self.fetchTasksFromURL(completion: completion)
            }
        }
    }

    func fetchTasksFromURL(completion: @escaping ([Task]) -> Void) {
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

    // MARK: - Update task

    func updateTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storage.saveTask(task) { success in
                if success {
                    if let index = self.cachedTasks.firstIndex(where: { $0.id == task.id }) {
                        self.cachedTasks[index] = task
                    }
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }

    // MARK: - Fetch tasks from Core Data

    func fetchTasksFromCoreData(completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.storage.fetchTasks { tasks in
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
    }

    // MARK: - Save tasks to Core Data

    func saveTasksToCoreData(tasks: [Task]) {
        DispatchQueue.global(qos: .background).async {
            tasks.forEach { task in
                self.storage.saveTask(task) { success in
                    guard success else { return }
                }
            }
        }
    }

    // MARK: - Delete task from Core Data

    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storage.deleteTask(task) { success in
                if success {
                    if let index = self.cachedTasks.firstIndex(where: { $0.id == task.id }) {
                        self.cachedTasks.remove(at: index)
                    }
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }
}
