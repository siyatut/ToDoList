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

    private let titleTextField = UIFactory.createTextField(
        placeholder: "Название задачи",
        font: UIFont.systemFont(ofSize: 34, weight: .bold)
    )
    private let descriptionTextView = UIFactory.createTextView(font: UIFont.systemFont(ofSize: 16))
    private let dateLastUpdateLabel = UIFactory.createLabel(font: UIFont.systemFont(ofSize: 12), textColor: .darkGray)
    private let doneButton = UIFactory.createTextButton(title: "Готово")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter?.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .systemYellow
        doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)

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

    // MARK: - Keyboard Handling

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: Notification) {
        doneButton.isEnabled = true
        doneButton.alpha = 1.0
    }

    @objc func keyboardWillHide(notification: Notification) {
        doneButton.isEnabled = false
        doneButton.alpha = 0.0
    }
}
