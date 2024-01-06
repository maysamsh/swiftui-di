//
//  ContentViewModelTests.swift
//  DI UnitTest
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import XCTest
import Combine

@testable import SwiftUI_DI

final class ContentViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let decoder = JSONDecoder()
    
    override func setUp() {
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func testFetch() {
        let service = MockAPIService(isSuccessful: true, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching images")
        
        sut.$images
            .dropFirst() // Drops the initial value at subscription time
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertEqual(value?.count ?? 0, 5)
            }
            .store(in: &cancellables)
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    func testFetchError() {
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching images")
        
        sut.$images
            .dropFirst() // Drops the initial value at subscription time
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertNil(value)
            }
            .store(in: &cancellables)
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
}
