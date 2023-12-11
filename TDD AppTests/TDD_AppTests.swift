//
//  TDD_AppTests.swift
//  TDD AppTests
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import XCTest
import Combine

@testable import TDD_App

final class TDD_AppTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func testFetch() {
        let service = MockAPIService(isSuccessful: true)
        let sut = ContentViewModel(apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching images")
        
        sut.$images
            .dropFirst() // Drops the initial value at subscription time
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertEqual(value?.count ?? 0, 5)
            }
            .store(in: &cancellables)
        sut.fetch()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    func testFetchError() {
        let service = MockAPIService(isSuccessful: false)
        let sut = ContentViewModel(apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching images")
        
        sut.$images
            .dropFirst() // Drops the initial value at subscription time
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertNil(value)
            }
            .store(in: &cancellables)
        sut.fetch()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
}
