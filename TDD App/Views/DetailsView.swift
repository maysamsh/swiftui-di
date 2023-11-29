//
//  ImageViewer.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-19.
//

import SwiftUI

final class DetailsViewModel: ObservableObject {
    
}

struct DetailsView: View {
    private let imageModel: ImageModel
    
    init(_ model: ImageModel) {
        self.imageModel = model
    }
    
    var body: some View {
        ScrollView {
            AsyncImage(url: self.imageModel.url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity, height: 300)
            } placeholder: {
                EmptyView()
            }

            Spacer()
        }
        .navigationTitle(self.imageModel.title)
    }
}

#Preview {
    let model = ImageModel(title: "A laptop on a desk",
                           url: URL(string: "https://picsum.photos/id/0/1000/600")!)
   return  DetailsView(model)
}
