//
//  TaskEditDelegate.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 26/2/2568 BE.
//

import UIKit

protocol TaskEditDelegate: AnyObject {
    func didUpdateTask(_ task: Task)
    func didAddTask(_ task: Task)
}
