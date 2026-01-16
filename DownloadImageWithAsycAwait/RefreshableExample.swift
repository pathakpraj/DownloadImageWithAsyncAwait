//
//  RefreshableExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/16/26.
//

import SwiftUI
import Observation

class Manager {
    func downLoadData() async throws -> [String] {
        try await Task.sleep(nanoseconds: 5_000_000_000)
        return ["One", "Two", "Three", "Four"].shuffled()
    }
}

@Observable
class RefreshableViewModel {
    private(set) var dataArray: [String] = []
    private(set) var isLoading = true
    private let manager = Manager()

    func getData() async {
        do {
            self.dataArray = try await manager.downLoadData()
            isLoading = false
        } catch {
            isLoading = false
            print(error.localizedDescription)
        }
    }
}

struct RefreshableExample: View {
    @State private var vm = RefreshableViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        ForEach(vm.dataArray, id: \.self) { str in
                            Text(str)
                        }
                    }
                }
            }
            .navigationTitle("Refreshable Example")
            .task {
                await vm.getData()
            }
            .refreshable {
                await vm.getData()
            }
        }
    }
}

#Preview {
    RefreshableExample()
}
