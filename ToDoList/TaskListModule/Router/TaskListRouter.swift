//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListRouter: TaskListRouterProtocol {

    // MARK: - Dependencies

    weak var viewController: TaskListView?

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
        navigateToTaskEdit(with: nil)
    }

    func navigateToEditTask(task: Task) {
        navigateToTaskEdit(with: task)
    }

    // MARK: - Private Methods

    private func navigateToTaskEdit(with task: Task?) {
        guard let viewController = viewController else { return }
        let taskEditView = TaskEditRouter.createModule(
            with: task,
            delegate: viewController.presenter as? TaskEditDelegate
        )
        viewController.navigationController?.pushViewController(taskEditView, animated: true)
    }
}
