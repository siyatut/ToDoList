//
//  TaskCell.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class TaskCell: UITableViewCell {

    // MARK: - Identifier

    static let identifier = "TaskCell"

    // MARK: - Callback

    var onCheckmarkTapped: (() -> Void)?

    // MARK: - UI components

    private let checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        button.setImage(UIImage(systemName: "circle", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    // MARK: - Properties

    private var isCompleted = false

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        setupUI()
        setupConstraints()
        addActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
    }

    // MARK: - Setup constraints

    private func setupConstraints() {
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: checkmarkButton.centerYAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Actions

    private func addActions() {
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
    }

    @objc private func checkmarkTapped() {
        onCheckmarkTapped?()
    }
    // MARK: - Configure

    func configure(with task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = task.dateCreated

        let textColor: UIColor = task.isCompleted ? .darkGray : .white
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .strikethroughStyle: task.isCompleted ? NSUnderlineStyle.single.rawValue : 0
        ]
        titleLabel.attributedText = NSAttributedString(string: task.title, attributes: titleAttributes)
        descriptionLabel.attributedText = NSAttributedString(string: task.description, attributes: titleAttributes)

        let imageName = task.isCompleted ? "checkmark.circle" : "circle"
        checkmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkmarkButton.tintColor = task.isCompleted ? .systemYellow : .darkGray
    }
}
