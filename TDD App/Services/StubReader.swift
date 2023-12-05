//
//  StubReader.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation
import OSLog

struct StubReader {
    static func readJson(_ filename: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: filename, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            } else {
                Logger.logError(FileError.notFound)
            }
        } catch {
            Logger.logError(error)
        }
        return nil
    }
}
