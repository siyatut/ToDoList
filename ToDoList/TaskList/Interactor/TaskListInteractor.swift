//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

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
        DispatchQueue.global(qos: .background).async {
            self.networkManager.fetchTasks(from: self.urlString) { result in
                switch result {
                case .success(let temporaryTasks):
                    let tasks = temporaryTasks.map(TaskMapper.map)
                    DispatchQueue.main.async {
                        completion(tasks)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }
    }

    // MARK: - Update task

    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async {
            if let index = self.cachedTasks.firstIndex(where: { $0.id == task.id }) {
                self.cachedTasks[index] = task
            }
        }
    }
}
