//
//  TaskListView+UISetuo.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import UIKit

extension TaskListView {

    // MARK: - UI setup

    func setupView() {
        setupNavigationBar()

        setupContainerView()
        setupmicrophoneButton()
        setupSearchBar()

        setupFooterView()
        setupTaskCountLabel()
        setupAddTaskButton()

        setupTableView()
        setupKeyboardDismissRecognizer()
    }

    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white

        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
    }

    func setupContainerView() {
        let customColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1.0)
        searchContainerView.backgroundColor = customColor
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        view.addSubview(searchContainerView)

        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            searchContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    func setupmicrophoneButton() {
        let microphoneImage = UIImage(systemName: "mic.fill")
        microphoneButton.setImage(microphoneImage, for: .normal)
        microphoneButton.tintColor = .darkGray
        searchContainerView.addSubview(microphoneButton)

        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            microphoneButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            microphoneButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            microphoneButton.widthAnchor.constraint(equalToConstant: 20),
            microphoneButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        microphoneButton.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
    }

    func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.borderStyle = .none

        searchBar.searchTextField.leftViewMode = .always
        searchBar.searchTextField.leftView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        searchBar.searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(-6, 0, 0)

        searchBar.searchTextField.leftView?.tintColor = .darkGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        searchContainerView.addSubview(searchBar)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: microphoneButton.leadingAnchor, constant: -8),
            searchBar.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor)
        ])
    }

    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        let customColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1.0)
        tableView.separatorColor = customColor
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: taskFooterView.topAnchor)
        ])
    }

    func setupFooterView() {
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

    }

    func setupTaskCountLabel() {
        taskCountLabel.font = UIFont.systemFont(ofSize: 11)
        taskCountLabel.textColor = .white

        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskCountLabel.centerXAnchor.constraint(equalTo: taskFooterView.centerXAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: taskFooterView.topAnchor, constant: 20.5),
            taskCountLabel.bottomAnchor.constraint(equalTo: taskFooterView.bottomAnchor, constant: -49.5)
        ])
    }

    func setupAddTaskButton() {
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

    func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
