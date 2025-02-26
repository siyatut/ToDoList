//
//  TaskEditInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditInteractorProtocol {
    func createTask(title: String, description: String) -> Task
    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void)
}

final class TaskEditInteractor: TaskEditInteractorProtocol {

    // MARK: - Dependencies

    private let storage: CoreDataManagerProtocol

    // MARK: - Init

    init(storage: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.storage = storage
    }

    // MARK: - Task Management

    func createTask(title: String, description: String) -> Task {
        return Task(
            id: UUID().uuidString,
            title: title,
            description: description,
            dateCreated: getFormattedDate(),
            dateUpdated: nil,
            isCompleted: false
        )
    }

    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storage.saveTask(task) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }

    private func getFormattedDate() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    }
}
