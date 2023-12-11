//
//  ContentViewModel.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-28.
//

import Foundation
import Combine
import OSLog

final class ContentViewModel: ObservableObject {
    @Published private (set) var images: [ImageModel]?
    private let apiService: NetworkingService
    private var cancellable: Set<AnyCancellable>
    
    init(apiService: NetworkingService = APIService()) {
        self.cancellable = Set<AnyCancellable>()
        self.apiService = apiService
    }
    
    func fetch() {
        apiService.fetchImages()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                if case let .failure(error) = result {
                    self?.images = nil
                    Logger.logError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.handleRespose(response)
            })
            .store(in: &cancellable)
    }
    
    private func handleRespose(_ response: SampleImagesResponse) {
        guard let responseImages = response.sample else {
            return
        }
        
        self.images = responseImages.compactMap { item in
            if let urlString = item.imageURL,
               let url = URL(string: urlString),
               let imageID = item.id,
               let title = item.description {
                return ImageModel(imageID: imageID, title: title, url: url)
            }
            return nil
        }
    }
}
