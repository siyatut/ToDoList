//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 31/1/2568 BE.
//

import UIKit

final class NetworkManager: NetworkManagerProtocol {

    // MARK: - Fetch tasks

    func fetchTasks(from urlString: String, completion: @escaping (Result<[TemporaryTask], Error>) -> Void) {
        print("NetworkManager: fetchTasks called")
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print("NetworkManager: URL is valid - \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("NetworkManager: request error - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("NetworkManager: no data received")
                completion(.failure(NSError(
                    domain: "",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                print("NetworkManager: data decoded successfully - \(decodedResponse.todos.count) tasks")
                completion(.success(decodedResponse.todos))
            } catch {
                print("NetworkManager: decoding error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
