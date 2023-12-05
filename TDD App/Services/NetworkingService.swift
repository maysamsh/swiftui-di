//
//  NetworkingService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

protocol NetworkingService: AnyObject {
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error>
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error>
}

enum NetworkingError: Error, CustomStringConvertible {
    case invalidURL
    case network(Error)
    case parsing(Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "# Invalid URL"
        case .network(let error):
            return "# Network error: \(error.localizedDescription)"
        case .parsing(let error):
            return "# Parsing error: \(error.localizedDescription)"
        }
    }

}
