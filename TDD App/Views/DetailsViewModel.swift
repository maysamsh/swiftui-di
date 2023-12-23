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
    private let dateFormatter = DateFormatter()
    
    init(imageModel: ImageModel, apiService: NetworkingService = APIService()) {
        self.apiService = apiService
        self.cancellable = Set<AnyCancellable>()
        self.extraData = [InfoItem]()
        self.imageModel = imageModel
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }
    
    var viewBackgroundColour: Color {
        imageExtraData?.colour.opacity(0.3) ?? Color.white
    }
    
    func fetch() {
        apiService.fetchImageDetails()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    print(error)
                }
            }, receiveValue: { [weak self] response in
                self?.handleRespose(response)
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
               let dateObject = item.date,
               let imageID = item.id {
                let colour = Color(hex: colourString)
                let date = formatDate(from: dateObject)
                return InfoItem(imageID: imageID, story: story, date: date, colour: colour)
            }
            return nil
        }
        print(extraData)
        findDataFor(id: imageModel.imageID)
    }
    
    private func findDataFor(id: String) {
        guard let image = self.extraData.filter({ $0.imageID == id }).first else {
            return
        }
        self.imageExtraData = image
    }
    
    private func formatDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
