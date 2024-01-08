//
//  Error+Ext.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation

enum FileError: Error, CustomStringConvertible, LocalizedError {
    case notFound
    case badData
    case reading (Error)
    
    var description: String {
        switch self {
        case .notFound:
            return "File not found"
        case .badData:
            return "Bad data in reading file"
        case .reading(let error):
            return "File reading error: \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? {
        return NSLocalizedString(self.description, comment: self.description)
    }
}

enum NetworkingError: Error, CustomStringConvertible, LocalizedError {
    case invalidURL
    case invalidResponse
    case testing
    case network(Error)
    case parsing(Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "The response is invalid."
        case .testing:
            return "Testing failed "
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .parsing(let error):
            return "Parsing error: \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? {
        return NSLocalizedString(self.description, comment: self.description)
    }

}

enum DetailsViewModelError: Error, CustomStringConvertible, LocalizedError {
    case invalidID
    case nilID
    case emptyDetailsList
    
    var description: String {
        switch self {
        case .invalidID:
            return "The image you are trying to see does not exist."
        case .nilID:
            return "Something went wrong, try again!"
        case .emptyDetailsList:
            return "Image detail is not available, try again later."
        }
    }
    
    var errorDescription: String? {
        return NSLocalizedString(self.description, comment: self.description)
    }
    
}
