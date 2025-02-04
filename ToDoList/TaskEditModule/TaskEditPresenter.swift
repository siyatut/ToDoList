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

    // MARK: - Init

    init(view: TaskEditViewProtocol,
         interactor: TaskEditInteractorProtocol,
         router: TaskEditRouterProtocol,
         task: Task?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.task = task
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        guard let task = task else {
            print("Error: task is nil")
            return
        }
        view?.updateTask(task)
    }

    // MARK: - User Actions

    func didTapSave(title: String, description: String) {
        let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

        if var task = task {
            task.title = title
            task.description = description
            task.dateUpdated = currentDate
            interactor.updateTask(task)
        } else {
            let newTask = Task(
                id: UUID().uuidString,
                title: title,
                description: description,
                dateCreated: currentDate,
                dateUpdated: currentDate,
                isCompleted: false
            )
            interactor.createTask(newTask)
        }
    }
}
