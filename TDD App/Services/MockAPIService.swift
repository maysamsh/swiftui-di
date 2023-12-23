//
//  MockAPIService.swift
//  TDD AppTests
//
//  Created by Maysam Shahsavari on 2023-12-10.
//

import Foundation
import Combine

final class MockAPIService: NetworkingService {
    private let contentFile: String
    private let detailFile: String
    private var isSuccessful: Bool
    private let jsonDecoder: JSONDecoder
    
    init(contentFile: String = "images-sample", 
         detailFile: String = "extra-data-sample",
         isSuccessful: Bool = true,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.contentFile = contentFile
        self.detailFile = detailFile
        self.isSuccessful = isSuccessful
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error> {
        guard isSuccessful else {
            return Fail(outputType: SampleImagesResponse.self, failure: NetworkingError.testing)
                .eraseToAnyPublisher()
        }
        
        do {
            if let data = try StubReader.readJson(self.contentFile) {
                let jsonData = try jsonDecoder.decode(SampleImagesResponse.self, from: data)
                return Result.Publisher(jsonData)
                    .eraseToAnyPublisher()
            } else {
                return Fail(outputType: SampleImagesResponse.self, failure: FileError.badData)
                    .eraseToAnyPublisher()
            }
        } catch {
            return Fail(outputType: SampleImagesResponse.self, failure: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error> {
        guard isSuccessful else {
            return Fail(outputType: ExtraDataResponse.self, failure: NetworkingError.testing)
                .eraseToAnyPublisher()
        }
        
        do {
            if let data = try StubReader.readJson(self.detailFile) {
                let jsonData = try jsonDecoder.decode(ExtraDataResponse.self, from: data)
                return Result.Publisher(jsonData)
                    .eraseToAnyPublisher()
            } else {
                return Fail(outputType: ExtraDataResponse.self, failure: FileError.badData)
                    .eraseToAnyPublisher()
            }
        } catch {
            return Fail(outputType: ExtraDataResponse.self, failure: error)
                .eraseToAnyPublisher()
        }
    }
    
}
