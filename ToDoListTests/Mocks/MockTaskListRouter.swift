//
//  MockTaskListRouter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import UIKit
@testable import ToDoList

final class MockTaskListRouter: TaskListRouterProtocol {

    var isNavigateToAddTaskCalled = false
    var isNavigateToEditTaskCalled = false
    var editedTask: Task?

    func navigateToAddTask() {
        isNavigateToAddTaskCalled = true
    }

    func navigateToEditTask(task: Task) {
        isNavigateToEditTaskCalled = true
        editedTask = task
    }
}
