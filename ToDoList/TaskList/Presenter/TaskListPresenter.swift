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

    // MARK: - Properties

    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private var isSearching: Bool = false

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
        fetchTasks()
    }

    // MARK: - Task loading

    private func fetchTasks() {
        interactor.fetchTasks { [weak self] fetchedTasks in
            guard let self = self else { return }
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
        return isSearching ? filteredTasks.count : tasks.count
    }

    func task(at index: Int) -> Task {
        return isSearching ? filteredTasks[index] : tasks[index]
    }

    // MARK: - User actions

    func didSelectTask(at index: Int) {
        let task = tasks[index]
        router.navigateToTaskDetail(task: task)
    }

    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
        taskUpdater.updateTask(tasks[index])
        let indexPath = IndexPath(row: index, section: 0)
        view?.updateTask(at: indexPath)
    }

    // MARK: - Search on tasks

    func searchTasks(with query: String) {
        if query.isEmpty {
            isSearching = false
            view?.updateTasks(tasks)
        } else {
            isSearching = true
            filteredTasks = tasks.filter { task in
                task.title.lowercased().contains(query.lowercased()) ||
                task.description.lowercased().contains(query.lowercased())
            }
            view?.updateTasks(filteredTasks)
        }
    }

    func cancelSearch() {
        isSearching = false
        view?.updateTasks(tasks)
    }
}
