//
//  TaskListRouterProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskListRouterProtocol {
    func navigateToAddTask()
    func navigateToEditTask(task: Task)
}
