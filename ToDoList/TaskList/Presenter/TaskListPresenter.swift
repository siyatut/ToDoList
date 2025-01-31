//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol?
    private var interactor: TaskListInteractorProtocol
    private var router: TaskListRouterProtocol
    private var tasks: [Task] = []
    
    init(view: TaskListViewProtocol, interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        updateView()
        fetchTasks()
    }
    
    func didTapAddTask() {
        router.navigateToAddTask()
    }
    
    func numberOfRows() -> Int {
        return tasks.count
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func didSelectTask(at index: Int) {
        let task = tasks[index]
        router.navigateToTaskDetail(task: task)
    }
    
    private func updateView() {
        view?.updateTasks(tasks)
    }
    
    private func fetchTasks() {
        interactor.fetchTasks { [weak self] fetchedTasks in
            guard let self = self else { return }
            self.tasks = fetchedTasks
            self.updateView()
        }
    }
}
