//
//  TaskMapper.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import UIKit

final class TaskMapper {
    static func map(_ temporaryTask: TemporaryTask) -> Task {
        return Task(
            id: temporaryTask.id,
            title: temporaryTask.todo,
            description: "Задача от пользователя с ID \(temporaryTask.userId)",
            dateCreated: "01/01/2025",
            isCompleted: temporaryTask.completed
        )
    }
}
