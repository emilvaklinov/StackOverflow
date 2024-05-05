//
//  NetworkManager.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "URLCreationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        print("Request URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Invalid body data")")
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Non-HTTP response received"])))
                return
            }
            print("Response status code: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NSError(domain: "InvalidHTTPResponse", code: -2, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: Status code \(httpResponse.statusCode)"])))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
