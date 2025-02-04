//
//  TaskEditRouter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditRouterProtocol {
    func dismissView()
}

final class TaskEditRouter: TaskEditRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(with task: Task?) -> UIViewController {
        let view = TaskEditView()
        let interactor = TaskEditInteractor()
        let router = TaskEditRouter()
        let presenter = TaskEditPresenter(
            view: view,
            interactor: interactor,
            router: router,
            task: task
        )

        view.presenter = presenter
        router.viewController = view
        return view
    }

    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
