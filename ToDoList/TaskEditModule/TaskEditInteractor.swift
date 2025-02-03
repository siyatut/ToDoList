//
//  TaskEditInteractor.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditInteractorProtocol {
    func createTask(_ task: Task)
    func updateTask(_ task: Task)
}

final class TaskEditInteractor: TaskEditInteractorProtocol {

    func createTask(_ task: Task) {
        CoreDataManager.shared.saveTask(task)
    }

    func updateTask(_ task: Task) {
        CoreDataManager.shared.updateTask(task)
    }
}
