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
    @Published private (set) var viewError: Error?
    private let apiService: NetworkingService
    private var cancellable: Set<AnyCancellable>
    private (set) var isAppeared = false

    // MARK: - Public Methods
    init(apiService: NetworkingService = APIService()) {
        self.cancellable = Set<AnyCancellable>()
        self.apiService = apiService
    }
    
    func viewDidAppear() {
        if !isAppeared {
            fetch()
            isAppeared = true
        }
    }
    
    // MARK: - Private Methods
    private func fetch() {
        apiService.fetchImages()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                if case let .failure(error) = result {
                    self?.images = nil
                    self?.viewError = error
                    Logger.logError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.images = self?.createImagesList(response)
            })
            .store(in: &cancellable)
    }
    
    func createImagesList(_ response: SampleImagesResponse) -> [ImageModel]? {
        guard let responseImages = response.sample else {
            Logger.logError(NetworkingError.invalidResponse)
            self.viewError = NetworkingError.invalidResponse
            return nil
        }
        
        self.viewError = nil
        return responseImages.compactMap { item in
            extractImage(item)
        }
    }
    
    func extractImage(_ item: SampleImagesResponse.ImageItem) -> ImageModel? {
        if let urlString = item.imageUrl,
           let url = URL(string: urlString),
           let imageID = item.id,
           let title = item.description, 
            url.isValid  {
            return ImageModel(imageID: imageID, title: title, url: url)
        }
        return nil
    }
}
