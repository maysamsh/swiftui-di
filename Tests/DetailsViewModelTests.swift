//
//  DetailsViewModelTests.swift
//  DI UnitTest
//
//  Created by Maysam Shahsavari on 2023-12-25.
//

import XCTest
import Combine

@testable import SwiftUI_DI

final class DetailsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let decoder = JSONDecoder()
    
    override func setUp() {
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
            .sink { value in
                fetchImagesExpectation.fulfill()
                XCTAssertNotNil(value?.colour)
            }
            .store(in: &cancellables)
        
        sut.viewDidAppear()
        wait(for: [fetchImagesExpectation], timeout: 1)

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
