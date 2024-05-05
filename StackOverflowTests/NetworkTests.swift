//
//  NetworkTests.swift
//  StackOverflowTests
//
//  Created by Emil Vaklinov on 05/05/2024.
//

import XCTest

final class NetworkTests: XCTestCase {
    
    func testLoadMockData() {
        let data = readDataFromFile("MockUserData", fileType: "json")
        XCTAssertNotNil(data, "Should have data loaded from the mock file.")
    }
    
    private func readDataFromFile(_ fileName: String, fileType: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
            return nil
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            XCTFail("Failed to load file: \(error)")
            return nil
        }
    }
}
