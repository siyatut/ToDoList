//
//  TaskEditInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditInteractorProtocol {
    func createTask(title: String, description: String) -> Task
    func updateTask(_ task: Task)
    func saveTask(_ task: Task)
    func createTemporaryTask() -> Task
    func getFormattedDate() -> String
}

final class TaskEditInteractor: TaskEditInteractorProtocol {
    
    // MARK: - Task Creation
    
    func createTask(title: String, description: String) -> Task {
        return Task(
            id: UUID().uuidString,
            title: title,
            description: description,
            dateCreated: getFormattedDate(),
            dateUpdated: getFormattedDate(),
            isCompleted: false
        )
    }
    
    func createTemporaryTask() -> Task {
        return Task(
            id: UUID().uuidString,
            title: "",
            description: "",
            dateCreated: getFormattedDate(),
            dateUpdated: nil,
            isCompleted: false
        )
    }
    
    func getFormattedDate() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    }
    
    func saveTask(_ task: Task) {
        CoreDataManager.shared.saveTask(task)
    }
    
    func updateTask(_ task: Task) {
        CoreDataManager.shared.updateTask(task)
    }
}
