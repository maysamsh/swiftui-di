//
//  ErrorView.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-12-24.
//

import SwiftUI

struct ErrorView: View {
    private let error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text(error.localizedDescription)
                .font(.title3)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ErrorView(DetailsViewModelError.invalidID)
}
