//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListPresenter: TaskListPresenterProtocol {

    // MARK: - Dependencies

    weak var view: TaskListViewProtocol?
    private var interactor: TaskListInteractorProtocol
    private var taskUpdater: TaskUpdating
    private var router: TaskListRouterProtocol
    private var tasks: [Task] = []

    // MARK: - Init

    init(
        view: TaskListViewProtocol,
        interactor: TaskListInteractorProtocol,
        taskUpdater: TaskUpdating,
        router: TaskListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.taskUpdater = taskUpdater
        self.router = router
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        print("Presenter: viewDidLoad called")
        fetchTasks()
    }

    // MARK: - Task loading

    private func fetchTasks() {
        print("Presenter: fetchTasks called")
        interactor.fetchTasks { [weak self] fetchedTasks in
            guard let self = self else { return }
            print("Presenter: tasks fetched - \(fetchedTasks.count)")
            self.tasks = fetchedTasks
            self.view?.updateTasks(fetchedTasks)
        }
    }

    // MARK: - Navigation

    func didTapAddTask() {
        router.navigateToAddTask()
    }

    // MARK: - Data Source

    func numberOfRows() -> Int {
        return tasks.count
    }

    func task(at index: Int) -> Task {
        return tasks[index]
    }

    // MARK: - User actions

    func didSelectTask(at index: Int) {
        let task = tasks[index]
        router.navigateToTaskDetail(task: task)
    }

    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
        taskUpdater.updateTask(tasks[index])
        view?.updateTasks(tasks)
    }
}
