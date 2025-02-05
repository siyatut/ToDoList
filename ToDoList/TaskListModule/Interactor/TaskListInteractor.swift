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
        CoreDataManager.shared.saveTask(task)
        if let index = self.cachedTasks.firstIndex(where: { $0.id == task.id }) {
            self.cachedTasks[index] = task
        }
    }

    // MARK: - Fetch tasks from Core Data

    func fetchTasksFromCoreData() -> [Task] {
        return CoreDataManager.shared.fetchTasks()
    }

    // MARK: - Save tasks to Core Data

    private func saveTasksToCoreData(tasks: [Task]) {
        tasks.forEach { task in
            CoreDataManager.shared.saveTask(task)
        }
    }

    // MARK: - Delete task from Core Data

    func deleteTask(_ task: Task) {
        CoreDataManager.shared.deleteTask(task)
    }
}
