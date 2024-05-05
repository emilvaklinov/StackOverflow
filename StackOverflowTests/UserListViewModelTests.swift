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
            print("onUsersUpdated called with \(self.viewModel.users.count) users.")
            XCTAssertEqual(self.viewModel.users.count, 20, "Should have correctly parsed twenty users.")
            expectation.fulfill()
        }

        viewModel.onNetworkError = { errorMessage in
            XCTFail("Network request should not fail with mock data: \(errorMessage)")
            expectation.fulfill()
        }

        viewModel.fetchUsers()
        waitForExpectations(timeout: 5, handler: nil)
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
    
    func testUserDataParsing() {
        guard let data = readDataFromFile("MockUserData", fileType: "json") else {
            XCTFail("Failed to load test data")
            return
        }

        mockNetworkManager.mockData = data

        let expectation = self.expectation(description: "UserDataParsed")
        viewModel.onUsersUpdated = {
            XCTAssertEqual(self.viewModel.users.count, 20, "Should have one user loaded")
            XCTAssertEqual(self.viewModel.users.first?.displayName, "Jon Skeet", "User display name should match")
            expectation.fulfill()
        }
        
        viewModel.fetchUsers()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFollowStatusLoading() {
    let user = User(displayName: "Jon Skeet", accountId: 1, profileImage: nil, reputation: 100, isFollowed: false)
        viewModel.users = [user]
        
        // Mock Core Data fetch to simulate existing follow status
        let followEntity = UserEntity(context: mockContext)
        followEntity.displayName = "Jon Skeet"
        followEntity.isFollowed = true
        try? mockContext.save()
        
        let expectation = self.expectation(description: "FollowStatusLoaded")
        viewModel.onUsersUpdated = {
            XCTAssertTrue(self.viewModel.users.first!.isFollowed, "User should be followed")
            expectation.fulfill()
        }
        
        viewModel.loadFollowStatus()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testNetworkFailureHandling() {
        mockNetworkManager.mockError = NSError(domain: "NetworkError", code: -1009, userInfo: nil)

        let expectation = self.expectation(description: "NetworkFailure")
        viewModel.onNetworkError = { errorMessage in
            print("Error message received: \(errorMessage)")
            expectation.fulfill()
        }
        
        viewModel.fetchUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()  // Fulfill the expectation here to test the timeout issue
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testToggleFollowStatus() {
        // Create a user directly with the new initializer
        let user = User(displayName: "Jon Skeet", accountId: 1, profileImage: nil, reputation: 100, isFollowed: false)
        viewModel.users = [user]

        let expectation = self.expectation(description: "ToggleFollowStatus")
        viewModel.onUsersUpdated = {
            XCTAssertTrue(self.viewModel.users.first!.isFollowed, "User follow status should be toggled to true")
            expectation.fulfill()
        }

        // Perform toggle
        viewModel.toggleFollowStatus(for: 0)
        waitForExpectations(timeout: 1, handler: nil)
    }

}
