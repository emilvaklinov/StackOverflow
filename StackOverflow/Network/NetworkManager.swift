//
//  NetworkManager.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

class NetworkManager {
    
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func fetchData(from endpoint: Endpoint, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.urlError))
            return
        }

        session.loadData(from: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.unknownError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.decodingError))
                return
            }

            completion(.success(data))
        }
    }
}
