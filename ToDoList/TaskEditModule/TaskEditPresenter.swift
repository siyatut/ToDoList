//
//  TaskEditPresenter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditPresenterProtocol {
    func viewDidLoad()
    func didTapSave(title: String, description: String)
}

final class TaskEditPresenter: TaskEditPresenterProtocol {

    // MARK: - Dependencies

    weak var view: TaskEditViewProtocol?
    private let interactor: TaskEditInteractorProtocol
    private let router: TaskEditRouterProtocol
    private var task: Task?
    weak var delegate: TaskEditDelegate?

    // MARK: - Init

    init(view: TaskEditViewProtocol,
         interactor: TaskEditInteractorProtocol,
         router: TaskEditRouterProtocol,
         task: Task?,
         delegate: TaskEditDelegate?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.task = task
        self.delegate = delegate
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        if let task = task {
            let formattedDate = formatDateToShow(task)
            view?.updateTask(task, formattedDate: formattedDate)
        } else {
            let newTask = interactor.createTask(title: "", description: "")
            let formattedDate = formatDateToShow(newTask)
            view?.updateTask(newTask, formattedDate: formattedDate)
        }
    }

    private func formatDateToShow(_ task: Task) -> String {
        return task.dateUpdated ?? task.dateCreated
    }

    func didTapSave(title: String, description: String) {
        let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

        if var task = task {
            task.title = title
            task.description = description
            task.dateUpdated = currentDate

            interactor.saveTask(task) { success in
                if success {
                    self.delegate?.didUpdateTask(task)
                    print("TaskEditPresenter: Task updated with title: \(title), description: \(description)")
                    self.router.dismissView()
                } else {
                    print("Failed to update task")
                }
            }
        } else {
            let newTask = interactor.createTask(title: title, description: description)
            interactor.saveTask(newTask) { success in
                if success {
                    self.delegate?.didAddTask(newTask)
                    print("TaskEditPresenter: Task added with title: \(title), description: \(description)")
                    self.router.dismissView()
                } else {
                    print("Failed to save new task")
                }
            }
        }
    }
}
