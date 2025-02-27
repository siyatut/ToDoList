//
//  MockCoreDataManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import Foundation
@testable import ToDoList

final class MockCoreDataManager: CoreDataManagerProtocol {

    var savedTasks: [Task] = []
    var deletedTasks: [Task] = []

    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        if let index = savedTasks.firstIndex(where: { $0.id == task.id }) {
            savedTasks[index] = task
        } else {
            savedTasks.append(task)
        }
        completion(true)
    }

    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        if let index = savedTasks.firstIndex(where: { $0.id == task.id }) {
            savedTasks.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        completion(savedTasks)
    }
}
