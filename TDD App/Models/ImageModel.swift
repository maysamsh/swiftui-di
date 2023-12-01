//
//  ImageModel.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-28.
//

import Foundation

struct ImageModel: Identifiable {
    let id = UUID()
    let imageID: String
    let title: String
    let url: URL
}
