//
//  ContentView.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import SwiftUI
import Combine

struct SampleImagesResponse: Codable {
    let sample: [ImageItem]?
    
    struct ImageItem: Codable {
        let description: String?
        let imageURL: String?

        enum CodingKeys: String, CodingKey {
            case description
            case imageURL = "image-url"
        }
    }
}

struct ImageModel: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

final class ViewModel: ObservableObject {
    let apiService: NetworkingService
    @Published private (set) var images: [ImageModel]
    private var cancellable: Set<AnyCancellable>
    
    init(apiService: NetworkingService = APIService()) {
        self.images = [ImageModel]()
        self.cancellable = Set<AnyCancellable>()
        self.apiService = apiService
    }
    
    func fetch() {
        guard let url = URL(string: "https://gist.githubusercontent.com/awadhawan18/54592d9ec5e7be1b39013cdd7e78dae4/raw/54a90fe99b8e821e273e1997f356d04308bdb232/Random-images.json") else {
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
            if let urlString = item.imageURL, let url = URL(string: urlString), let title = item.description {
                return ImageModel(title: title, url: url)
            }
            return nil
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.images) { item in
                HStack {
                    AsyncImage(url: item.url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        EmptyView()
                    }
                    Text(item.title)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    ContentView()
}
