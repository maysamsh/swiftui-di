//
//  DetailsViewModel.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-30.
//

import Foundation
import Combine
import SwiftUI

final class DetailsViewModel: ObservableObject {
    @Published private (set) var imageExtraData: InfoItem?
    
    private var extraData: [InfoItem]
    private let imageModel: ImageModel
    private let apiService: NetworkingService
    private var cancellable: Set<AnyCancellable>

    init(imageModel: ImageModel, apiService: NetworkingService = APIService()) {
        self.apiService = apiService
        self.cancellable = Set<AnyCancellable>()
        self.extraData = [InfoItem]()
        self.imageModel = imageModel
        fetch()
    }
    
    func fetch() {
        apiService.fetchImageDetails()
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    print(error)
                }
            }, receiveValue: { response in
                Task {@MainActor [weak self] in
                    self?.handleRespose(response)
                }
            })
            .store(in: &cancellable)
    }
    
    private func handleRespose(_ response: ExtraDataResponse) {
        guard let extraDataResponse = response.sample else {
            return
        }
        
        self.extraData = extraDataResponse.compactMap { item in
            if let story  = item.story,
               let colourString = item.colour,
               let imageID = item.id {
                let colour = Color(hex: colourString)
                return InfoItem(imageID: imageID, story: story, colour: colour)
            }
            return nil
        }
        
        findDataFor(id: imageModel.imageID)
    }
    
    private func findDataFor(id: String) {
        guard let image = self.extraData.filter({ $0.imageID == id }).first else {
            return
        }
        
        self.imageExtraData = image
    }
}
