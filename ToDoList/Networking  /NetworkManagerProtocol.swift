//
//  NetworkManagerProtocol.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//

import UIKit

protocol NetworkManagerProtocol {
    func fetchTasks(from urlString: String, completion: @escaping (Result<[TemporaryTask], Error>) -> Void)
}
