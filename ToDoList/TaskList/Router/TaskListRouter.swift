//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListRouter: TaskListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToAddTask() {
        print("Navigate to Add Task screen")
    }
    
    func navigateToTaskDetail(task: Task) {
        print("Navigate to Task Detail screen for: \(task.title)")
    }
}
