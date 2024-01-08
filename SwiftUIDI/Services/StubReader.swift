//
//  StubReader.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-03.
//

import Foundation

struct StubReader {
    static func readJson(_ filename: String) throws -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: filename, ofType: "json"), !filename.isEmpty {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            } else {
                throw FileError.notFound
            }
        } catch {
            throw FileError.reading(error)
        }
    }
}
