//
//  MockCoreDataManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import Foundation
@testable import ToDoList

final class MockCoreDataManager: CoreDataManager {

    var savedTasks: [Task] = []
    var deletedTasks: [Task] = []

    override func saveTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        savedTasks.append(task)
        completion(true)
    }

    override func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        deletedTasks.append(task)
        completion(true)
    }

    override func fetchTasks(completion: @escaping ([Task]) -> Void) {
        completion(savedTasks)
    }
}
