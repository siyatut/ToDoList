//
//  TaskListInteractorProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskListInteractorProtocol {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
    func updateTask(_ task: Task)
}
