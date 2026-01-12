//
//  AsynPublisherExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/12/26.
//

// async Publisher allows us to subscribe anything published using combine to be used in Async environment of Swift Concurrency

import SwiftUI
import Combine

class AsyncPublishDataManager {
    @Published var dataArray: [String] = []

    func addData() async  {
        dataArray.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("Cashew")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        dataArray.append("Mango")
    }
}

class AsyncPublishViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let dataManager = AsyncPublishDataManager()

    init() {
        addSubscriber()
    }

    private func addSubscriber() {
        Task {
            for await data in dataManager.$dataArray.values  {
                self.dataArray = data
            }
        }
    }

    func start() async {
        await dataManager.addData()
    }

}

struct AsynPublisherExample: View {
    @StateObject private var viewModel: AsyncPublishViewModel = AsyncPublishViewModel()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsynPublisherExample()
}
