//
//  DetailsViewModel.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-30.
//

import Foundation
import Combine
import SwiftUI
import OSLog

final class DetailsViewModel: ObservableObject {
    @Published private (set) var imageExtraData: InfoItem?
    @Published private (set) var viewError: Error?
    @Published private var extraData: [InfoItem]?

    private (set) var isAppeared = false
    private var cancellable: Set<AnyCancellable>
    private let apiService: NetworkingService
    private let dateFormatter = DateFormatter()
    let imageModel: ImageModel
    let defaultColourString = "#FFFFFF"
    
    // MARK: - Public Methods
    init(imageModel: ImageModel, apiService: NetworkingService = APIService()) {
        self.apiService = apiService
        self.cancellable = Set<AnyCancellable>()
        self.imageModel = imageModel
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }
    
    // MARK: - Public Variables
    func viewDidAppear() {
        if !isAppeared {
            fetch()
            isAppeared = true
        }
    }
    
    var viewBackgroundColour: Color {
        imageExtraData?.colour.opacity(0.3) ?? Color(hex: self.defaultColourString)
    }
    
    private func fetch() {
        apiService.fetchImageDetails()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                if case let .failure(error) = result {
                    self?.imageExtraData = nil
                    self?.viewError = error
                    Logger.logError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.extraData = self?.createImagesDetailsList(response)
                self?.findDataFor(id: self?.imageModel.imageID)
            })
            .store(in: &cancellable)
    }
    
    // MARK: - Private Methods
    func createImagesDetailsList(_ response: ExtraDataResponse) -> [InfoItem] {
        guard let extraDataResponse = response.sample else {
            self.viewError = NetworkingError.invalidURL
            return []
        }
        
        self.viewError = nil
        return extraDataResponse.compactMap { item in
            extractDetails(item)
        }
    }

    func extractDetails(_ item: ExtraDataResponse.InfoItem) -> InfoItem? {
        if let story  = item.story,
           let dateObject = item.date,
           let imageID = item.id {
            let colourString = item.colour ?? defaultColourString
            let colour = Color(hex: colourString)
            let date = formatDate(from: dateObject)
            return InfoItem(imageID: imageID, story: story, date: date, colour: colour)
        }
        return nil
    }
    
    func findDataFor(id: String?) {
        guard let id else {
            viewError = DetailsViewModelError.nilID
            return
        }
        
        guard let extraData else {
            viewError = DetailsViewModelError.emptyDetailsList
            return
        }
        
        guard let image = extraData.filter({ $0.imageID == id }).first else {
            Logger.logError(DetailsViewModelError.invalidID)
            self.viewError = DetailsViewModelError.invalidID
            return
        }
        self.viewError = nil
        self.imageExtraData = image
    }
    
    func formatDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
