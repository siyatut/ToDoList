//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListInteractor: TaskListInteractorProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let urlString = "https://dummyjson.com/todos"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        networkManager.fetchTasks(from: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let temporaryTasks):
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
                    print("Error fetching tasks: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
}
