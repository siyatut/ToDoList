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

    private let checkmarkButton = UIFactory.createButton(systemImageName: "circle", tintColor: .darkGray)
    private let titleLabel = UIFactory.createLabel(font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private let descriptionLabel = UIFactory.createLabel(font: UIFont.systemFont(ofSize: 14), numberOfLines: 2)
    private let dateLabel = UIFactory.createLabel(font: UIFont.systemFont(ofSize: 12), textColor: .darkGray)
    private let backgroundContainerView = UIFactory.createContainerView()

    // MARK: - Properties

    private var isCompleted = false

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
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
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(checkmarkButton)
        backgroundContainerView.addSubview(titleLabel)
        backgroundContainerView.addSubview(descriptionLabel)
        backgroundContainerView.addSubview(dateLabel)
    }

    // MARK: - Setup constraints

    private func setupConstraints() {
        backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            checkmarkButton.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 20),
            checkmarkButton.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 12),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: checkmarkButton.centerYAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -12)
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
        dateLabel.text = task.dateUpdated ?? task.dateCreated

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

    func setMenuHighlight(_ highlighted: Bool) {
        let customColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1.0)
        let targetColor: UIColor = highlighted ? customColor : .black

        UIView.animate(withDuration: 0.2) {
            self.backgroundContainerView.backgroundColor = targetColor
        }
    }
}
