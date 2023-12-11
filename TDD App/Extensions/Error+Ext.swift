//
//  Error+Ext.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation

enum FileError: Error, CustomStringConvertible {
    case notFound
    case badData
    case reading (Error)
    
    var description: String {
        switch self {
        case .notFound:
            return "# File not found"
        case .badData:
            return "# Bad data in reading file"
        case .reading(let error):
            return "# File reading error: \(error.localizedDescription)"
        }
    }
}
