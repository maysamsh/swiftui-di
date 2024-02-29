//
//  ImageViewer.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-19.
//

import SwiftUI

struct DetailsView: View {
    @StateObject private var viewModel: DetailsViewModel
    private let imageModel: ImageModel
    
    init(_ model: ImageModel, apiSerrvice: NetworkingService) {
        self.imageModel = model
        _viewModel = StateObject(wrappedValue: DetailsViewModel(imageModel: model, apiService: apiSerrvice))
    }
    
    @ViewBuilder
    private var content: some View {
        if let error = viewModel.viewError {
            ErrorView(error)
        } else {
            ScrollView {
                AsyncImage(url: self.imageModel.url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    EmptyView()
                }
                if let extraData = viewModel.imageExtraData {
                    VStack(alignment: .leading) {
                        Text(extraData.date)
                            .font(.caption)
                        
                        Text(extraData.story)
                            .padding(.top)
                    }
                    .padding(.leading)
                }
                Spacer()
            }
        }
    }
    
    var body: some View {
        content
        .onAppear {
            viewModel.viewDidAppear()
        }
        .navigationTitle(self.imageModel.title)
        .background(viewModel.viewBackgroundColour)
    }
}

#Preview {
    let model = ImageModel(imageID: "4cdad0d1-aef8-48a5-832b-18c6c973f084", title: "A laptop on a desk",
                           url: URL(string: "https://picsum.photos/id/0/1000/600")!)
    let apiService: NetworkingService = APIService.previewAPIService()
    return  DetailsView(model, apiSerrvice: apiService)
}
