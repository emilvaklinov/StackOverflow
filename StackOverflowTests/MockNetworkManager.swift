//
//  MockNetworkManager.swift
//  StackOverflowTests
//
//  Created by Emil Vaklinov on 05/05/2024.
//

import Foundation
@testable import StackOverflow
import CoreData

class MockNetworkManager: NetworkManager {
    var mockData: Data?
    var mockError: Error?
    
    override func fetchData(from endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let data = mockData {
            completion(.success(data))
        }
    }
}

extension NSPersistentContainer {
    static func inMemoryContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "StackOverflow")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }
}
