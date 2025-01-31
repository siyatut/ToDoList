//
//  TaskCellPresenterProtocol..swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskCellPresenterProtocol: AnyObject {
    func configure(task: Task)
    func toggleTaskCompletion()
}
