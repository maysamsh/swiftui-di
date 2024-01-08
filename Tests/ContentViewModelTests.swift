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
    
    func testViewDidAppear() {
        let service = MockAPIService(isSuccessful: true, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)
    
        XCTAssertFalse(sut.isAppeared)
        sut.viewDidAppear()
        XCTAssertTrue(sut.isAppeared)
    }
    
    func testFetchError() {
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching images")
        
        sut.$images
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertNotNil(sut.viewError)
                XCTAssertNil(value)
            }
            .store(in: &cancellables)
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    func testResponseMissingSample() {
        guard let data = try? StubReader.readJson("images-sample-no-sample-object") else {
            XCTFail("Could not read the file.")
            return
        }
        
        guard let response = try? self.decoder.decode(SampleImagesResponse.self, from: data) else {
            XCTFail("Could not read the file.")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)

        let imagesList = sut.createImagesList(response)
        XCTAssertNotNil(sut.viewError)
        XCTAssertNil(imagesList)
    }
    
    func testImagesListWithBadItems() {
        guard let data = try? StubReader.readJson("images-sample-bad-data") else {
            XCTFail("Could not read the file.")
            return
        }
        
        guard let response = try? self.decoder.decode(SampleImagesResponse.self, from: data) else {
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)

        let imagesList = sut.createImagesList(response)
        XCTAssertEqual(imagesList?.count, 1)
    }
    
    func testBadImageItem() {
        guard let data = try? StubReader.readJson("images-sample-bad-data") else {
            XCTFail("Could not read the file.")
            return
        }
        
        guard let images = try? self.decoder.decode(SampleImagesResponse.self, from: data).sample else {
            XCTFail("Could not decode data.")
            return
        }
        
        guard images.count == 4 else {
            XCTFail("The number of items should be 4.")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = ContentViewModel(apiService: service)

        /// Bad URL
        let image1 = images[0]
        let imageModel1 = sut.extractImage(image1)
        XCTAssertNil(imageModel1)
        
        /// Missing ID
        let image2 = images[1]
        let imageModel2 = sut.extractImage(image2)
        XCTAssertNil(imageModel2)
        
        /// Missing Description
        let image3 = images[2]
        let imageModel3 = sut.extractImage(image3)
        XCTAssertNil(imageModel3)
    }
}
