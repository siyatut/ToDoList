//
//  MockTaskListView.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import Foundation
@testable import ToDoList

final class MockTaskListView: TaskListViewProtocol {

    var tasks: [Task] = []
    var deletedTaskIndexPaths: [IndexPath] = []

    func updateTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }

    func updateTask(at indexPath: IndexPath) {}

    func deleteTask(at indexPath: IndexPath) {
        deletedTaskIndexPaths.append(indexPath)
        if indexPath.row < tasks.count {
            tasks.remove(at: indexPath.row)
        }
    }

    func showShareSheet(for task: Task) {}

    func resetHighlightForCell(at indexPath: IndexPath) {}
}
