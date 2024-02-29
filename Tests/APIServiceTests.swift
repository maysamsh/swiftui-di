//
//  APIServiceTests.swift
//  SwiftUI-DITests
//
//  Created by Maysam Shahsavari on 2024-02-27.
//

import XCTest
import Combine

@testable import SwiftUI_DI

final class APIServiceTests: XCTestCase {
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()

    var apiService: NetworkingService!

    let imagesUrl: URL? = URL(string: "https://gist.githubusercontent.com/maysamsh/bd3b57b4bd9266de24bfc3203fc5f85b/raw/7aab6637578eb2ec8f8cf674189449603c2ee3ef/images-sample.json")
    let extraDataUrl: URL? = URL(string: "https://gist.githubusercontent.com/maysamsh/c539e299b061591a1e316f0fcac598b2/raw/e12f85fe0b792f5dc7a374aeb7ff9889f178c44e/extra-data-sample.json")
    
    var imagesUrlData: Data {
        try! StubReader.readJson("images-sample")!
    }
    
    var extraInfoData: Data {
        try! StubReader.readJson("extra-data-sample")!
    }
    
    override func setUp() {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        MockURLProtocol.testURLs = [imagesUrl: imagesUrlData, extraDataUrl: extraInfoData]
        let config = URLSessionConfiguration.ephemeral
        URLProtocol.registerClass(MockURLProtocol.self)
        let urlsSession: URLSession = URLSession(configuration: config)
        self.apiService = APIService(urlSession: urlsSession,
                                     decoder: decoder,
                                     imagesPath: RemoteAssets.images,
                                     extraDataPath: RemoteAssets.extraData)
    }
    
    func testURLs() throws {
        XCTAssertEqual(apiService.imagesPath, "https://gist.githubusercontent.com/maysamsh/bd3b57b4bd9266de24bfc3203fc5f85b/raw/7aab6637578eb2ec8f8cf674189449603c2ee3ef/images-sample.json")
        XCTAssertEqual(apiService.extraDataPath, "https://gist.githubusercontent.com/maysamsh/c539e299b061591a1e316f0fcac598b2/raw/e12f85fe0b792f5dc7a374aeb7ff9889f178c44e/extra-data-sample.json")
    }
    
    func testDecoderSnakeCaseConverter() {
        let expectation = XCTestExpectation(description: "Fetch images")
        apiService.fetchImages()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { response in
                expectation.fulfill()
                if response.sample?.first?.imageUrl != nil {
                    XCTAssert(true)
                } else {
                    XCTExpectFailure("Decoder failed to decode from snake_case")
                }
            })
            .store(in: &cancellable)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDecoderDateTimeFormatter() {
        let expectation = XCTestExpectation(description: "Fetch images")
        apiService.fetchImageDetails()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { response in
                expectation.fulfill()
                if response.sample?.first?.date?.timeIntervalSince1970 == 1700687077.0 {
                    XCTAssert(true)
                } else {
                    XCTExpectFailure("Decoder failed to decode from snake_case")
                }
            })
            .store(in: &cancellable)
        wait(for: [expectation], timeout: 2.0)
    }
}
