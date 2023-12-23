//
//  ImageViewer.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-19.
//

import SwiftUI

struct DetailsView: View {
    @StateObject private var viewModel: DetailsViewModel
    @State private var isAppeared = false

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
        .onAppear {
            if !isAppeared {
                viewModel.fetch()
                isAppeared = true
            }
        }
        .navigationTitle(self.imageModel.title)
        .background(viewModel.viewBackgroundColour)
    }
}

#Preview {
    let model = ImageModel(imageID: "", title: "A laptop on a desk",
                           url: URL(string: "https://picsum.photos/id/0/1000/600")!)
   return  DetailsView(model)
}
