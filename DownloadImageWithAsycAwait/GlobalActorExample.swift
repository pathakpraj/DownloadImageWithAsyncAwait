//
//  GlobalActorExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/12/26.
//

// @MainActor is a global actor which isolates execution to the main thread
// by using @globalActor, we define a custom global actor and have separate isolated domains
// for different purposes like image processing, data handling etc
// we can isolate a method, property or entire class to main or global actor
// we must provide private init along with shared instance so that it cannot be initiated in
// other places and will need shared instance to be used to provide a single isolation domain.

import SwiftUI
import Combine


@globalActor
actor DataManager {
    static var shared: DataManager = DataManager()
    private init() { }

    func getDataFromDB() async -> [String] {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return ["One", "Two", "Three"]
    }
}

class GlobalActorExampleViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    private let manager = DataManager.shared

    func getData() async {
        self.dataArray =  await manager.getDataFromDB()
    }
}

struct GlobalActorExample: View {
    @StateObject var viewModel = GlobalActorExampleViewModel()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { str in
                    Text(str)
                }
            }
            .task {
                await viewModel.getData()
            }
        }
    }
}

#Preview {
    GlobalActorExample()
}
