//
//  APIService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

final class APIService: NetworkingService {
    func request<ResponseType>(type: ResponseType.Type, url: URL) -> AnyPublisher<ResponseType, Error> where ResponseType: Decodable {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseType.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
