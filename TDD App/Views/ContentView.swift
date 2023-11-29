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
        let id: String?

        enum CodingKeys: String, CodingKey {
            case description
            case imageURL = "image-url"
            case id
        }
    }
}

struct ImageModel: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

struct RemoteAssets {
    static let extraData = "https://gist.github.com/maysamsh/c539e299b061591a1e316f0fcac598b2/raw/b1f6b90db9bb41ebd55788ce482e9a33ebaf8186/extra-data-sample.json"
    static let images = "https://gist.github.com/maysamsh/bd3b57b4bd9266de24bfc3203fc5f85b/raw/9df83e13163d1aed04c4dc6be68264ad6ca6cda7/images-sample.json"
}

final class ContentViewModel: ObservableObject {
    let apiService: NetworkingService
    @Published private (set) var images: [ImageModel]
    private var cancellable: Set<AnyCancellable>
    
    init(apiService: NetworkingService = APIService()) {
        self.images = [ImageModel]()
        self.cancellable = Set<AnyCancellable>()
        self.apiService = apiService
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
            if let urlString = item.imageURL, let url = URL(string: urlString), let title = item.description {
                return ImageModel(title: title, url: url)
            }
            return nil
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ContentViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(viewModel.images) { item in
                    NavigationLink {
                        DetailsView(item)
                    } label: {
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
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    ContentView()
}
