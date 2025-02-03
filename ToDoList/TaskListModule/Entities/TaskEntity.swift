//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import Foundation

struct TodoResponse: Decodable {
    let todos: [TemporaryTask]
}

struct TemporaryTask: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct Task: Decodable {
    let id: Int
    var title: String
    var description: String
    var dateCreated: String
    var dateUpdated: String?
    var isCompleted: Bool
}
