//
//  TaskMapper.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import UIKit

final class TaskMapper {
    static func map(_ temporaryTask: TemporaryTask) -> Task {
        let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        return Task(
            id: String(temporaryTask.id),
            title: temporaryTask.todo,
            description: "Задача от пользователя с ID \(temporaryTask.userId)",
            dateCreated: currentDate,
            isCompleted: temporaryTask.completed
        )
    }
}
