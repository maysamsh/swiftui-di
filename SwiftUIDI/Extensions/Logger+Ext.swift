//
//  Logger.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    private static let error = Logger(subsystem: subsystem, category: "error")
    
    static func logError(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let extraInfo = "\(file), \(function), at: \(line)\n\t"
        Logger.error.info("\(error.localizedDescription)\(extraInfo)")
        #else
        Logger.error.info("\(error.localizedDescription)")
        #endif
    }
}
