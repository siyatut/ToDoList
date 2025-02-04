//
//  TaskEditView.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 3/2/2568 BE.
//

import UIKit

protocol TaskEditViewProtocol: AnyObject {
    func updateTask(_ task: Task, formattedDate: String)
}

final class TaskEditView: UIViewController, TaskEditViewProtocol {

    // MARK: - Dependencies

    var presenter: TaskEditPresenterProtocol?

    // MARK: - UI Components

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название задачи"
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.borderStyle = .none
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let dateLastUpdateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .systemYellow
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton

        view.addSubview(titleTextField)
        view.addSubview(dateLastUpdateLabel)
        view.addSubview(descriptionTextView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            dateLastUpdateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLastUpdateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dateLastUpdateLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: dateLastUpdateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions

    private func saveChanges() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text else { return }
        presenter?.didTapSave(title: title, description: description)
    }

    // MARK: - Display Data

    func updateTask(_ task: Task, formattedDate: String) {
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        dateLastUpdateLabel.text = formattedDate
    }
}
