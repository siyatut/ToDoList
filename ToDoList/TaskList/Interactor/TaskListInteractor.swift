//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListInteractor: TaskListInteractorProtocol {
    func fetchTasks() -> [Task] {
        return [
            Task(
                title: "Купить продукты",
                description: "Хлеб, молоко",
                dateCreated: "01.01.2025",
                isCompleted: false
            ),
            Task(
                title: "Прочитать книгу",
                description: "20 страниц в день",
                dateCreated: "02.01.2025",
                isCompleted: true
            )
        ]
    }
}
