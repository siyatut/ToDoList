//
//  TaskListView+DataSourceDelegate.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import UIKit

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
        cell.onCheckmarkTapped = { [weak self] in
            self?.presenter?.toggleTaskCompletion(at: indexPath.row)
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let index = indexPath.row

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")) { _ in
                self.presenter?.didSelectEditTask(at: index)
            }

            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.presenter?.didSelectShareTask(at: index)
            }

            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                self.presenter?.didSelectDeleteTask(at: index)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
