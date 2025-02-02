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
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard self != nil else { return }
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(
                    domain: "",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(decodedResponse.todos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
