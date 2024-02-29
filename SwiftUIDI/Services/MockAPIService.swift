//
//  MockAPIService.swift
//  DI UnitTest
//
//  Created by Maysam Shahsavari on 2023-12-10.
//

import Foundation
import Combine

final class MockAPIService: NetworkingService {
    let imagesPath: String
    let extraDataPath: String
    
    private let contentFile: String
    private let detailFile: String
    private var isSuccessful: Bool
    let decoder: JSONDecoder
    
    init(contentFile: String = "images-sample", 
         detailFile: String = "extra-data-sample",
         isSuccessful: Bool = true,
         jsonDecoder: JSONDecoder) {
        self.contentFile = contentFile
        self.detailFile = detailFile
        self.isSuccessful = isSuccessful
        self.decoder = jsonDecoder
        self.imagesPath = ""
        self.extraDataPath = ""
    }
    
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error> {
        guard isSuccessful else {
            return Fail(outputType: SampleImagesResponse.self, failure: NetworkingError.testing)
                .eraseToAnyPublisher()
        }
        
        do {
            if let data = try StubReader.readJson(self.contentFile) {
                let jsonData = try decoder.decode(SampleImagesResponse.self, from: data)
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
                let jsonData = try decoder.decode(ExtraDataResponse.self, from: data)
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
