//
//  SampleImagesResponse.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-28.
//

import Foundation

struct SampleImagesResponse: Codable {
    let sample: [ImageItem]?
    
    struct ImageItem: Codable {
        let description: String?
        let imageUrl: String?
        let id: String?
    }
}
