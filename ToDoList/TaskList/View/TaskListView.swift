//
//  ViewController.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 30/1/2568 BE.
//

import UIKit

final class TaskListView: UIViewController, TaskListViewProtocol {

    // MARK: - Properties

    private var tasks: [Task] = []
    var presenter: TaskListPresenterProtocol?
    var selectedIndexPath: IndexPath?

    // MARK: - UI components

    let tableView = UITableView()
    let taskFooterView = UIView()
    let taskCountLabel = UILabel()
    let addTaskButton = UIButton()

    let searchContainerView = UIView()
    let searchBar = UISearchBar()
    let microphoneButton = UIButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }

    // MARK: - Actions

    @objc func addTaskTapped() {
        presenter?.didTapAddTask()
    }

    @objc func didTapMicrophoneButton() {
        presenter?.didTapMicrophone()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func showShareSheet(for task: Task) {
        let activityController = UIActivityViewController(
            activityItems: [task.title],
            applicationActivities: nil
        )
        present(activityController, animated: true)
    }

    // MARK: - UI updates

    func updateTaskCountLabel() {
        let taskCount = tasks.count
        let taskWord: String

        if taskCount == 1 {
            taskWord = "задача"
        } else if taskCount > 1 && taskCount < 5 {
            taskWord = "задачи"
        } else {
            taskWord = "задач"
        }

        let taskCountText = "\(taskCount) \(taskWord)"

        DispatchQueue.main.async {
            self.taskCountLabel.text = taskCountText
        }
    }

    func updateTask(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func updateTasks(_ tasks: [Task]) {
        self.tasks = tasks
        updateTaskCountLabel()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
