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
    private var router: TaskListRouterProtocol

    // MARK: - Properties

    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private var isSearching: Bool = false

    // MARK: - Init

    init(
        view: TaskListViewProtocol,
        interactor: TaskListInteractorProtocol,
        router: TaskListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
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
            DispatchQueue.main.async {
                self.view?.updateTasks(fetchedTasks)
            }
        }
    }

    // MARK: - Navigation

    func didTapAddTask() {
        router.navigateToAddTask()
    }

    func didSelectTask(at index: Int) {
        let task = isSearching ? filteredTasks[index] : tasks[index]
        router.navigateToEditTask(task: task)
    }

    // MARK: - Data Source

    func numberOfRows() -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }

    func task(at index: Int) -> Task {
        return isSearching ? filteredTasks[index] : tasks[index]
    }

    func updateTask(_ task: Task) {
        interactor.updateTask(task) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    let updatedTasks = self?.fetchTasksFromCoreData() ?? []
                    self?.view?.updateTasks(updatedTasks)
                }
            }
        }
    }

    func fetchTasksFromCoreData() -> [Task] {
        var tasksFromCoreData: [Task] = []
        interactor.fetchTasksFromCoreData { tasks in
            tasksFromCoreData = tasks
        }
        return tasksFromCoreData
    }

    // MARK: - User actions

    func toggleTaskCompletion(at index: Int) {
        var task = isSearching ? filteredTasks[index] : tasks[index]
        task.isCompleted.toggle()

        interactor.updateTask(task) { [weak self] success in
            if success {
                self?.view?.updateTask(at: IndexPath(row: index, section: 0))
            }
        }

        if isSearching {
            filteredTasks[index] = task
        } else {
            tasks[index] = task
        }

    }

    func didTapMicrophone() {
        print("Presenter: вызов голосового помощника")
    }

    // MARK: - Search on tasks

    func searchTasks(with query: String) {
        guard !query.isEmpty else {
            isSearching = false
            DispatchQueue.main.async {
                self.view?.updateTasks(self.tasks)
            }
            return
        }

        isSearching = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let filteredTasks = self.tasks.filter { task in
                task.title.lowercased().contains(query.lowercased()) ||
                task.description.lowercased().contains(query.lowercased())
            }

            DispatchQueue.main.async {
                self.filteredTasks = filteredTasks
                self.view?.updateTasks(filteredTasks)
            }
        }
    }

    func cancelSearch() {
        isSearching = false
        DispatchQueue.main.async {
            self.view?.updateTasks(self.tasks)
        }
    }

    // MARK: - Long press menu handling

    func didSelectEditTask(at index: Int) {
        let task = isSearching ? filteredTasks[index] : tasks[index]
        router.navigateToEditTask(task: task)
    }

    func didSelectShareTask(at index: Int) {
        let task = isSearching ? filteredTasks[index] : tasks[index]
        view?.showShareSheet(for: task)
    }

    func didSelectDeleteTask(at index: Int) {
        let taskToDelete = isSearching ? filteredTasks[index] : tasks[index]
        interactor.deleteTask(taskToDelete) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.view?.deleteTask(at: IndexPath(row: index, section: 0))
                }
            }
        }

        view?.resetHighlightForCell(at: IndexPath(row: index, section: 0))

        if isSearching {
            if let originalIndex = tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
                tasks.remove(at: originalIndex)
            }
            filteredTasks.remove(at: index)
        } else {
            tasks.remove(at: index)
        }
    }
}

extension TaskListPresenter: TaskEditDelegate {

    func didUpdateTask(_ task: Task) {
        interactor.updateTask(task) { [weak self] success in
            if success {
                if let index = self?.tasks.firstIndex(where: { $0.id == task.id }) {
                    self?.tasks[index] = task
                    self?.view?.updateTask(at: IndexPath(row: index, section: 0))
                    print("TaskListPresenter: Task updated in list with title: \(task.title)")
                }
            }
        }
    }

    func didAddTask(_ task: Task) {
        guard !tasks.contains(where: { $0.id == task.id }) else {
               print("TaskListPresenter: Task with ID \(task.id) already exists")
               return
           }
        tasks.append(task)
        DispatchQueue.main.async {
            self.view?.updateTasks(self.tasks)
        }
        print("TaskListPresenter: Task added to list with title: \(task.title)")
    }
}
