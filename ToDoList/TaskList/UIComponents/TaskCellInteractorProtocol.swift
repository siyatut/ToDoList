//
//  TaskCellInteractorProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

protocol TaskCellInteractorInputProtocol: AnyObject {
    func updateTask(_ task: Task)
}
