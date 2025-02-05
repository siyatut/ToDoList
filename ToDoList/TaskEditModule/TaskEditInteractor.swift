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
    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void)
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
        saveTask(newTask) { success in
            if success {
                print("Task created successfully: \(newTask.title)")
            } else {
                print("Failed to create task")
            }
        }

        return newTask
    }

    func getFormattedDate() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    }

    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.saveTask(task) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
}
