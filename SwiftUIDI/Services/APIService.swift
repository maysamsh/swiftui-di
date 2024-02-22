//
//  APIService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

final class APIService: NetworkingService {
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error> {
        guard let url = URL(string: RemoteAssets.images + "t") else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        return request(type: SampleImagesResponse.self, url: url)
    }
    
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error> {
        guard let url = URL(string: RemoteAssets.extraData) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        return request(type: ExtraDataResponse.self, url: url)
    }
    
    private func request<ResponseType>(type: ResponseType.Type, url: URL) -> AnyPublisher<ResponseType, Error> where ResponseType: Decodable {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseType.self, decoder: decoder)
            .eraseToAnyPublisher()
    }    
}
