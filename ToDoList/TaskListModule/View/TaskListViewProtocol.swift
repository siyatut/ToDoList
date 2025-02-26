//
//  TaskListViewProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func updateTasks(_ tasks: [Task])
    func updateTask(at indexPath: IndexPath)
    func deleteTask(at indexPath: IndexPath)
    func showShareSheet(for task: Task)
    func resetHighlightForCell(at indexPath: IndexPath)
}
