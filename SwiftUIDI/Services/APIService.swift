//
//  APIService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

final class APIService: NetworkingService {
    let imagesPath: String
    let extraDataPath: String
    let decoder: JSONDecoder
    let session: URLSession
    
    init(urlSession: URLSession,
         decoder: JSONDecoder,
         imagesPath: String,
         extraDataPath: String) {
        self.imagesPath = imagesPath
        self.extraDataPath = extraDataPath
        self.decoder = decoder
        self.session = urlSession
    }
    
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error> {
        guard let url = URL(string: imagesPath) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        return request(type: SampleImagesResponse.self, url: url)
    }
    
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error> {
        guard let url = URL(string: extraDataPath) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        return request(type: ExtraDataResponse.self, url: url)
    }
    
    private func request<ResponseType>(type: ResponseType.Type, url: URL) -> AnyPublisher<ResponseType, Error> where ResponseType: Decodable {
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseType.self, decoder: decoder)
            .eraseToAnyPublisher()
    }    
}
extension APIService {
    static func previewAPIService() -> APIService {
        let session: URLSession = URLSession.shared
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return APIService(urlSession: session,
                          decoder: decoder,
                          imagesPath: RemoteAssets.images,
                          extraDataPath: RemoteAssets.extraData)
    }
}
