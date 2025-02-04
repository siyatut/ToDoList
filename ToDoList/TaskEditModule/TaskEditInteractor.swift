//
//  TaskEditInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditInteractorProtocol {
    func createTask(title: String, description: String) -> Task
    func getFormattedDate() -> String
    func saveTask(_ task: Task)
}

final class TaskEditInteractor: TaskEditInteractorProtocol {

    func createTask(title: String, description: String) -> Task {
        let newTask = Task(
            id: UUID().uuidString,
            title: title,
            description: description,
            dateCreated: getFormattedDate(),
            dateUpdated: getFormattedDate(),
            isCompleted: false
        )
        saveTask(newTask)

        return newTask
    }

    func getFormattedDate() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    }

    func saveTask(_ task: Task) {
        CoreDataManager.shared.saveTask(task)
    }
}
