//
//  DownloadImageAsyncViewModel.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 12/17/25.
//

import Foundation
import SwiftUI
import Combine

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private var imageLoader = DownloadImageAsyncImageLoader()

    func fetchImage() async {

        // with escaping closure
        /*
//        imageLoader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.image = image
//            }
//            if let error {
//                print(error.localizedDescription)
//            }
//        }
         */

        // with combine
        /*
        imageLoader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
         */

        // with async
        image = try? await imageLoader.downloadImageWithAsync()
    }

}
