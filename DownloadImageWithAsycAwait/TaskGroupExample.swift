//
//  TaskGroupExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/4/26.
//

import SwiftUI
import Foundation
import Combine

class ImageManager {

    func fetchImagesWithTaskGroup() async -> [UIImage] {
        let urls = ["https://picsum.photos/200",
                    "https://picsum.photos/200",
                    "https://picsum.photos/200",
                    "https://picsum.photos/200",
                    "https://picsum.photos/200"]

        var images = [UIImage]()
        images.reserveCapacity(urls.count)

        do {
             try await withThrowingTaskGroup(of: UIImage?.self) { group in

                for urlString in urls {
                    group.addTask {
                        try? await self.fetchImage(urlString: urlString)
                    }
                }

                for try await image in group {
                    if let image {
                        images.append(image)
                    }
                }
            }
        } catch {
            print("something went wrong with fetching images.")
        }
        
        return images
    }

    private func fetchImage(urlString: String) async throws-> UIImage? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupExampleViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    private let imageManager = ImageManager()


    func fetchImages() async {
        self.images.append(contentsOf: await imageManager.fetchImagesWithTaskGroup())
    }

}

struct TaskGroupExample: View {
    @StateObject var viewModel: TaskGroupExampleViewModel = TaskGroupExampleViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchImages()
            }
        }
    }
}

#Preview {
    TaskGroupExample()
}
