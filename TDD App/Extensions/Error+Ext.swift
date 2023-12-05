//
//  Error+Ext.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation

enum FileError: Error, CustomStringConvertible {
    case notFound
    
    var description: String {
        switch self {
        case .notFound:
            return "File not found"
        }
    }
}
