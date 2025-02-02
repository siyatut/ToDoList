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
            dateCreated: "02/10/2024",
            isCompleted: temporaryTask.completed
        )
    }
}
