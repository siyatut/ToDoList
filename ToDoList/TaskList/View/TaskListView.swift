//
//  ViewController.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 30/1/2568 BE.
//

import UIKit

final class TaskListView: UIViewController, TaskListViewProtocol {

    private var tasks: [Task] = []
    var presenter: TaskListPresenterProtocol?

    private let tableView = UITableView()
    private let taskFooterView = UIView()
    private let taskCountLabel = UILabel()
    private let addTaskButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        view.backgroundColor = .black
        setupNavigationBar()
        setupFooter()
        setupTableView()
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white

        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
    }

    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: taskFooterView.topAnchor)
        ])
    }

    private func setupFooter() {
        let customColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1.0)
        taskFooterView.backgroundColor = customColor
        view.addSubview(taskFooterView)
        taskFooterView.addSubview(taskCountLabel)
        taskFooterView.addSubview(addTaskButton)

        taskFooterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskFooterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskFooterView.heightAnchor.constraint(equalToConstant: 83)
        ])

        taskCountLabel.font = UIFont.systemFont(ofSize: 11)
        taskCountLabel.textColor = .white
        updateTaskCountLabel()

        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskCountLabel.centerXAnchor.constraint(equalTo: taskFooterView.centerXAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: taskFooterView.topAnchor, constant: 20.5),
            taskCountLabel.bottomAnchor.constraint(equalTo: taskFooterView.bottomAnchor, constant: -49.5)
        ])

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "square.and.pencil")
        config.baseForegroundColor = .yellow
        config.buttonSize = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        addTaskButton.configuration = config
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        taskFooterView.addSubview(addTaskButton)

        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskButton.centerYAnchor.constraint(equalTo: taskCountLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: taskFooterView.trailingAnchor, constant: -16)
        ])
    }

    @objc private func addTaskTapped() {
        presenter?.didTapAddTask()
    }

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

    func updateTasks(_ tasks: [Task]) {
        self.tasks = tasks
        updateTaskCountLabel()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension TaskListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = presenter?.task(at: indexPath.row),
              let cell = tableView.dequeueReusableCell(
                withIdentifier: TaskCell.identifier,
                for: indexPath
              ) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configure(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
    }
}
