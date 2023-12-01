//
//  ContentViewModel.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-28.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published private (set) var images: [ImageModel]
    private let apiService: NetworkingService
    private var cancellable: Set<AnyCancellable>
    
    init(apiService: NetworkingService = APIService()) {
        self.images = [ImageModel]()
        self.cancellable = Set<AnyCancellable>()
        self.apiService = apiService
        fetch()
    }
    
    func fetch() {
        guard let url = URL(string: RemoteAssets.images) else {
            return
        }
        
        apiService.request(type: SampleImagesResponse.self, url: url)
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
