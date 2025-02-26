//
//  CoreDataReadable.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 26/2/2568 BE.
//

protocol CoreDataReadable {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
}

protocol CoreDataWritable {
    func saveTask(_ task: Task, completion: @escaping (Bool) -> Void)
    func deleteTask(_ task: Task, completion: @escaping (Bool) -> Void)
}

protocol CoreDataManagerProtocol: CoreDataReadable, CoreDataWritable {}
