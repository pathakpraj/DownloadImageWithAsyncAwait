//
//  AsyncLetExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/3/26.
//

import SwiftUI

struct AsyncLetExample: View {
    @State private var images: [UIImage] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 2)) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                    }
                }
            }
            .navigationTitle("Async Let!!")
        }
        .onAppear {
            Task {
                async let fetchImage1 = fetchImage()
                async let fetchImage2 = fetchImage()
                async let fetchImage3 = fetchImage()
                async let fetchImage4 = fetchImage()

                let (image1, image2, image3, image4) = await (try fetchImage1,
                try fetchImage2, try fetchImage3, try fetchImage4)
                images.append(contentsOf: [image1, image2, image3, image4])
            }
        }
    }

    func fetchImage() async throws-> UIImage {
        let url = URL(string: "https://picsum.photos/200")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)!
            return image
        } catch {
            throw error
        }
    }
}

#Preview {
    AsyncLetExample()
}
