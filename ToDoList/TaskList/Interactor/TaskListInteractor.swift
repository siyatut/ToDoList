//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListInteractor: TaskListInteractorProtocol {

    private let networkManager: NetworkManagerProtocol
    private var cachedTasks: [Task] = []
    private let urlString = "https://dummyjson.com/todos"

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        print("Interactor: fetchTasks called")
        networkManager.fetchTasks(from: "https://dummyjson.com/todos") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let temporaryTasks):
                    print("Interactor: fetchTasks called")
                    let tasks = temporaryTasks.map { temporaryTask in
                        Task(
                            id: temporaryTask.id,
                            title: temporaryTask.todo,
                            description: "Задача от пользователя с ID \(temporaryTask.userId)",
                            dateCreated: "01/01/2025",
                            isCompleted: temporaryTask.completed
                        )
                    }
                    completion(tasks)
                case .failure(let error):
                    print("Interactor: network error - \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }

    func updateTask(_ task: Task) {
        if let index = cachedTasks.firstIndex(where: { $0.id == task.id }) {
            cachedTasks[index] = task
        }
    }
}
