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
    
    init(_ model: ImageModel) {
        self.imageModel = model
        _viewModel = StateObject(wrappedValue: DetailsViewModel(imageModel: model))
    }
    
    var body: some View {
        ScrollView {
            AsyncImage(url: self.imageModel.url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } placeholder: {
                EmptyView()
            }
            if let extraData = viewModel.imageExtraData {
                Text(extraData.story)
                    .font(.caption)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle(self.imageModel.title)
        .background(viewModel.imageExtraData?.colour ?? Color.white)
    }
}

#Preview {
    let model = ImageModel(imageID: "", title: "A laptop on a desk",
                           url: URL(string: "https://picsum.photos/id/0/1000/600")!)
   return  DetailsView(model)
}
