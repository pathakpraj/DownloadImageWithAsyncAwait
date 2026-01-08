//
//  ContinuationExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/8/26.
//

import SwiftUI
import Combine

class NetworkManager {

    // using swift concurrency Async await
    func fetchImage(url: URL) async throws -> Data {
        do {
            let (data, _)  = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }

    // using escaping closures and continuations
    func fetchImageWithContinuation(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }

    // function returning image from DB with escaping clouser
    func fetchImageFromDatabase(completion: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completion(UIImage(systemName: "heart.fill")!)
        }
    }

    // convert above function to async using continuation
    func fetchImageFromDatabase() async -> UIImage {
       return  await withCheckedContinuation { continuation in
            fetchImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class ContinuationExampleViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private var manager = NetworkManager()

    func getImage(url: String) async  {
        guard let imageURL = URL(string: url) else { return }
        do {
            let data = try await manager.fetchImageWithContinuation(url: imageURL)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error.localizedDescription)
        }

    }
}
struct ContinuationExample: View {
    @StateObject private var viewModel = ContinuationExampleViewModel()

    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .task {
            await viewModel.getImage(url: "https://picsum.photos/200")
        }
    }
}

#Preview {
    ContinuationExample()
}
