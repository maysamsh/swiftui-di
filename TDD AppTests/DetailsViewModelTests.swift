//
//  DetailsViewModelTests.swift
//  TDD AppTests
//
//  Created by Maysam Shahsavari on 2023-12-25.
//

import XCTest
import Combine

@testable import TDD_App

final class DetailsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testImageDetail() {
        guard let image = fetchTestImage() else {
            XCTFail("The image is nil")
            return
        }
        
        let service = MockAPIService(isSuccessful: true)
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
        
        guard let image = try? JSONDecoder().decode(SampleImagesResponse.self, from: data).sample?.first else {
            return nil
        }
        
        guard let urlString = image.imageURL,
                let url = URL(string: urlString),
                let title = image.description,
                let id = image.id else {
                return nil
        }
        return ImageModel(imageID: id, title: title, url: url)
    }

}
