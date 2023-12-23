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
        let date: Date?
        
        enum CodingKeys: String, CodingKey {
            case id
            case story
            case colour
            case date
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<ExtraDataResponse.InfoItem.CodingKeys> = try decoder.container(keyedBy: ExtraDataResponse.InfoItem.CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: ExtraDataResponse.InfoItem.CodingKeys.id)
            self.story = try container.decodeIfPresent(String.self, forKey: ExtraDataResponse.InfoItem.CodingKeys.story)
            self.colour = try container.decodeIfPresent(String.self, forKey: ExtraDataResponse.InfoItem.CodingKeys.colour)
            /// Date formatter are expensive, you might need to move this entire conversion into your view model
            /// It's here just for the sake of an example of a custom decoder.
            if let stringDate = try container.decodeIfPresent(String.self, forKey: ExtraDataResponse.InfoItem.CodingKeys.date) {
                let formatter = ISO8601DateFormatter()
                self.date = formatter.date(from: stringDate)
            } else {
                self.date = nil
            }
        }
    }
}
