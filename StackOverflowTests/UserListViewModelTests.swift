//
//  UserListViewModelTests.swift
//  StackOverflowTests
//
//  Created by Emil Vaklinov on 05/05/2024.
//

import XCTest
@testable import StackOverflow
import CoreData

final class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        let container = NSPersistentContainer.inMemoryContainer()
        mockContext = container.viewContext
        viewModel = UserListViewModel(networkManager: mockNetworkManager, context: mockContext)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testFetchUsersUsingMockData() {
        guard let mockData = readDataFromFile("MockUserData", fileType: "json") else {
            XCTFail("No data available for mocking.")
            return
        }
        
        mockNetworkManager.mockData = mockData
        let expectation = self.expectation(description: "Users fetched using mock data")
        
        viewModel.onUsersUpdated = {
            XCTAssertEqual(self.viewModel.users.count, 20, "Should have correctly parsed one user.")
            expectation.fulfill()
        }
        
        viewModel.onNetworkError = { errorMessage in
            XCTFail("Network request should not fail with mock data: \(errorMessage)")
            expectation.fulfill()
        }
        
        viewModel.fetchUsers()
        waitForExpectations(timeout: 1, handler: nil)
    }

    private func readDataFromFile(_ fileName: String, fileType: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
            XCTFail("File not found: \(fileName).\(fileType)")
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            XCTFail("Failed to load file from test bundle: \(error)")
            return nil
        }
    }
}
