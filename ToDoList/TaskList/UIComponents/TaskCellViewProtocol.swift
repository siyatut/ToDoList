//
//  TaskCellViewProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskCellViewProtocol: AnyObject {
    func display(taskTitle: String, taskDescription: String, date: String, isCompleted: Bool)
}
