//
//  DownloadImageAsyncView.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 12/17/25.
//

import SwiftUI

struct DownloadImageAsyncView: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear() {
            Task {
               await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsyncView()
}
