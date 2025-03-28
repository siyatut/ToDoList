//
//  MockTaskListInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import Foundation
@testable import ToDoList

final class MockTaskListInteractor: TaskListInteractorProtocol {

    var cachedTasks: [Task] = []
    var isFetchCalled = false
    var isDeleteCalled = false
    var isUpdateCalled = false

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        isFetchCalled = true
        completion(cachedTasks)
    }

    func updateTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        isUpdateCalled = true
        if let index = cachedTasks.firstIndex(where: { $0.id == task.id }) {
            cachedTasks[index] = task
            completion(true)
        } else {
            completion(false)
        }
    }

    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        isDeleteCalled = true
        if let index = cachedTasks.firstIndex(where: { $0.id == task.id }) {
            cachedTasks.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }
}
