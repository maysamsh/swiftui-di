//
//  SwiftUIDIUnitTestApp.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import SwiftUI

@main
struct SwiftUIDIUnitTestApp: App {
    let session: URLSession = URLSession.shared
    let decoder: JSONDecoder = JSONDecoder()
    let apiService: NetworkingService
    
    init() {
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
        self.apiService = APIService(urlSession: session, 
                                     decoder: decoder,
                                     imagesPath: RemoteAssets.images, 
                                     extraDataPath: RemoteAssets.extraData)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(apiService: apiService)
        }
    }
}
