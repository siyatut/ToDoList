//
//  MockNetworkManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import Foundation
@testable import ToDoList

final class MockNetworkManager: NetworkManagerProtocol {

    var fetchSuccess: Bool = true
    var tasks: [TemporaryTask] = []

    func fetchTasks(from urlString: String, completion: @escaping (Result<[TemporaryTask], Error>) -> Void) {
        if fetchSuccess {
            completion(.success(tasks))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }
}
