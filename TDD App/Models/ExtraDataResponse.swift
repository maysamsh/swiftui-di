//
//  ExtraDataResponse.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-28.
//

import Foundation

struct ExtraDataResponse: Codable {
    let sample: [InfoItem]?
    
    struct InfoItem: Codable {
        let id: String?
        let story: String?
        let colour: String?
    }
}
