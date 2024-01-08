//
//  DetailsViewModelTests.swift
//  DI UnitTest
//
//  Created by Maysam Shahsavari on 2023-12-25.
//

import XCTest
import Combine
import SwiftUI

@testable import SwiftUI_DI

final class DetailsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let decoder = JSONDecoder()
    
    override func setUp() {
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func testFetchError() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching image details")
        
        sut.$imageExtraData
            .dropFirst()
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertNil(value)
            }
            .store(in: &cancellables)
        
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    func testImageDetail() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil")
            return
        }
        
        let service = MockAPIService(isSuccessful: true, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching image details")
        
        sut.$imageExtraData
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { value in
                fetchImagesExpectation.fulfill()
                let imageID = value?.imageID
                XCTAssertNotNil(imageID)
                XCTAssertEqual(imageID, sut.imageModel.imageID)
                XCTAssertEqual(sut.viewBackgroundColour, Color(hex: "#f8805a").opacity(0.3))
                
                let date = value?.date
                XCTAssertEqual(date, "November 22, 2023 at 4:04 PM")
            }
            .store(in: &cancellables)
        
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    func testViewDidAppear() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil")
            return
        }
        
        let service = MockAPIService(isSuccessful: true, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        
        XCTAssertFalse(sut.isAppeared)
        sut.viewDidAppear()
        XCTAssertTrue(sut.isAppeared)
    }
    
    func testImageDetailWithBadItem() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil")
            return
        }
        
        guard let details = fetchImageDetailList("extra-data-sample-bad-data")?.sample else {
            XCTFail("Could not read the file.")
            return
        }
        
        guard details.count == 4 else {
            XCTFail("The number of items should be 4.")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        
        /// Missing ID
        let detail1 = details[0]
        let extraInfo1 = sut.extractDetails(detail1)
        XCTAssertNil(extraInfo1)
        
        /// Missing Story
        let detail2 = details[1]
        let extraInfo2 = sut.extractDetails(detail2)
        XCTAssertNil(extraInfo2)
        
        /// Missing Colour
        let detail3 = details[2]
        let extraInfo3 = sut.extractDetails(detail3)
        XCTAssertEqual(extraInfo3?.colour, Color(hex: sut.defaultColourString))
        XCTAssertEqual(sut.viewBackgroundColour, Color(hex: sut.defaultColourString))

        /// Missing Date
        let detail4 = details[3]
        let extraInfo4 = sut.extractDetails(detail4)
        XCTAssertNil(extraInfo4)
    }
    
    func testResponseMissingSample() {
        guard let response = fetchImageDetailList("images-sample-no-sample-object") else {
            XCTFail("Could not decode the file.")
            return
        }
        
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil.")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        
        let imagesList = sut.createImagesDetailsList(response)
        XCTAssertNotNil(sut.viewError)
        XCTAssertTrue(imagesList.isEmpty)
    }
    
    func testFindID() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil.")
            return
        }
        
        let service = MockAPIService(isSuccessful: false, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        
        sut.findDataFor(id: nil)
        XCTAssertNotNil(sut.viewError)
        
        sut.findDataFor(id: image.imageID)
        XCTAssertNotNil(sut.viewError)
    }
    
    func testWrongID() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil.")
            return
        }
        
        let service = MockAPIService(isSuccessful: true, jsonDecoder: self.decoder)
        let sut = DetailsViewModel(imageModel: image, apiService: service)
        let fetchImagesExpectation = expectation(description: "Fetching image details")
        
        sut.$imageExtraData
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { value in
                fetchImagesExpectation.fulfill()
                sut.findDataFor(id: "")
                XCTAssertNotNil(sut.viewError)
            }
            .store(in: &cancellables)
        
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)
    }
    
    private func fetchImageDetailList(_ fileName: String) -> ExtraDataResponse? {
        guard let data = try? StubReader.readJson(fileName) else {
            XCTFail("Could not read the file.")
            return nil
        }
        
        guard let response = try? self.decoder.decode(ExtraDataResponse.self, from: data) else {
            XCTFail("Could not decode the file.")
            return nil
        }
        
        return response
    }
    
    private func fetchTestImage() -> ImageModel? {
        guard let data = try? StubReader.readJson("images-sample") else {
            return nil
        }
        
        guard let image = try? self.decoder.decode(SampleImagesResponse.self, from: data).sample?.first else {
            return nil
        }
        
        guard let urlString = image.imageUrl,
              let url = URL(string: urlString),
              let title = image.description,
              let id = image.id else {
            return nil
        }
        return ImageModel(imageID: id, title: title, url: url)
    }
}
