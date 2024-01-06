//
//  InfoItem.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-30.
//

import Foundation
import SwiftUI

struct InfoItem: Identifiable {
    let id = UUID()
    let imageID: String
    let story: String
    let date: String
    let colour: Color
}
