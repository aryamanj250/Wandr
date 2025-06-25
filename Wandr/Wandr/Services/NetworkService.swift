//
//  NetworkService.swift
//  Wandr
//
//  Created by Cascade on 25/06/25.
//

import Foundation

struct TaskResponse: Codable {
    let message: String
    let taskId: String
    let status: String
}

struct CommandResult: Codable {
    let status: String
    let result: String? // Changed to String? to hold raw JSON
    let error: String?
}

class NetworkService {
    private let baseURL = "http://192.168.1.3:8000/api/v1"

    func sendTextCommand(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/process-text-command") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["text": text]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let taskResponse = try JSONDecoder().decode(TaskResponse.self, from: data)
                completion(.success(taskResponse.taskId))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getCommandResult(taskId: String, completion: @escaping (Result<CommandResult, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get-command-result/\(taskId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let commandResult = try JSONDecoder().decode(CommandResult.self, from: data)
                completion(.success(commandResult))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
