//
//  NetworkingService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

protocol NetworkingService: AnyObject {
    func request<ResponseType: Decodable>(type: ResponseType.Type, url: URL) -> AnyPublisher<ResponseType, Error>
}

enum NetworkingError: Error, CustomStringConvertible {
    case network(Error)
    case parsing(Error)
    
    var description: String {
        switch self {
        case .network(let error):
            return "# Network error: \(error.localizedDescription)"
        case .parsing(let error):
            return "# Parsing error: \(error.localizedDescription)"
        }
    }

}
