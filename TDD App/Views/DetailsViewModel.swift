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
    private var isAppeared = false
    private var extraData: [InfoItem]
    private var cancellable: Set<AnyCancellable>
    private let imageModel: ImageModel
    private let apiService: NetworkingService
    private let dateFormatter = DateFormatter()
    
    // MARK: - Public Methods
    init(imageModel: ImageModel, apiService: NetworkingService = APIService()) {
        self.apiService = apiService
        self.cancellable = Set<AnyCancellable>()
        self.extraData = [InfoItem]()
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
        imageExtraData?.colour.opacity(0.3) ?? Color.white
    }
    
    private func fetch() {
        apiService.fetchImageDetails()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                if case let .failure(error) = result {
                    Logger.logError(error)
                    self?.viewError = error
                } else {
                    self?.viewError = nil
                }
            }, receiveValue: { [weak self] response in
                self?.handleRespose(response)
            })
            .store(in: &cancellable)
    }
    
    // MARK: - Private Methods
    private func handleRespose(_ response: ExtraDataResponse) {
        guard let extraDataResponse = response.sample else {
            self.viewError = NetworkingError.invalidURL
            return
        }
        self.viewError = nil
        self.extraData = extraDataResponse.compactMap { item in
            if let story  = item.story,
               let colourString = item.colour,
               let dateObject = item.date,
               let imageID = item.id {
                let colour = Color(hex: colourString)
                let date = formatDate(from: dateObject)
                return InfoItem(imageID: imageID, story: story, date: date, colour: colour)
            }
            return nil
        }
        findDataFor(id: imageModel.imageID)
    }
    
    private func findDataFor(id: String) {
        guard let image = self.extraData.filter({ $0.imageID == id }).first else {
            Logger.logError(DetailsViewModelError.invalidID)
            self.viewError = DetailsViewModelError.invalidID
            return
        }
        self.viewError = nil
        self.imageExtraData = image
    }
    
    private func formatDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
