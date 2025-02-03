//
//  TaskListPresenterProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfRows() -> Int
    func task(at index: Int) -> Task
    
    func didTapAddTask()
    func didSelectTask(at index: Int)
    func toggleTaskCompletion(at index: Int)
    
    func searchTasks(with query: String)
    func cancelSearch()
    func didTapMicrophone()
    
    func didSelectEditTask(at index: Int)
    func didSelectShareTask(at index: Int)
    func didSelectDeleteTask(at index: Int)
}
