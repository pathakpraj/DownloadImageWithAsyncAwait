//
//  DownloadImageAsyncImageLoader.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 12/17/25.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!

    func handleResponse(_ data: Data?,_ response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response  = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  return nil
              }
        return image
    }

    func downloadWithEscaping(completion: @escaping (_ image: UIImage?,_ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data, response)
            completion(image, error)
        }
        .resume()
    }

    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }

    func downloadImageWithAsync() async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        let image = handleResponse(data, response)
        return image
    }
}
