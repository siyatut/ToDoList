//
//  TaskListPresenterProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAddTask()
    func numberOfRows() -> Int
    func task(at index: Int) -> Task
    func didSelectTask(at index: Int)
    func toggleTaskCompletion(at index: Int)
    func searchTasks(with query: String)
    func cancelSearch()
}
