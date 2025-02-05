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
            router: router
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }

    // MARK: - Navigation

    func navigateToAddTask() {
        guard let taskListView = viewController as? TaskListView,
              let presenter = taskListView.presenter else {
            return
        }
        let taskEditView = TaskEditRouter.createModule(with: nil, delegate: presenter as? TaskEditDelegate)
        viewController?.navigationController?.pushViewController(taskEditView, animated: true)
    }

    func navigateToEditTask(task: Task) {
        guard let taskListView = viewController as? TaskListView,
              let presenter = taskListView.presenter else {
            return
        }
        let taskEditView = TaskEditRouter.createModule(with: task, delegate: presenter as? TaskEditDelegate)
        viewController?.navigationController?.pushViewController(taskEditView, animated: true)
    }
}
