//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListRouter: TaskListRouterProtocol {

    // MARK: - Dependencies

    weak var viewController: UIViewController?

    // MARK: - Module Creation

    static func createModule() -> UIViewController {
        let view = TaskListView()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(
            view: view,
            interactor: interactor,
            taskUpdater: interactor,
            router: router
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }

    // MARK: - Navigation

    func navigateToAddTask() {
        print("Navigate to Add Task screen")
    }

    func navigateToEditTask(task: Task) {
        print("Navigate to Edit Task: \(task.title)")
    }
}
