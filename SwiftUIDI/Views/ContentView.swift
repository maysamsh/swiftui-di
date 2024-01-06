//
//  ContentView.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ContentViewModel())
    }
    
    @ViewBuilder
    private var content: some View {
        if let error = viewModel.viewError {
            ErrorView(error)
        } else {
            VStack(alignment: .leading) {
                if let images = viewModel.images {
                    ForEach(images) { item in
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
        }
    }
    
    var body: some View {
        NavigationStack {
            content
            .onAppear {
                viewModel.viewDidAppear()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
