//
//  SendableExample.swift
//  DownloadImageWithAsycAwait
//
//  Created by Prajakta Pathak on 1/12/26.
//

// Senable protocol indicated that a custom reference type is send to be sent to async //
// environment
// all value types such as String, Int, struct, enum are by default sendable as they are stored on stack
// class and function types are reference types which are stored on heap are not sendable
// we can use actor instead of class to be thread safe but some times using class in unavoidable
// if a class contains let const, we can make it sendable but if its mutable, it needs to be made sendable.
// we can use @unchecked Sendable to override compiler warning but its then our responsibility to make it thread safe.
// to make your class sendable when it has mutable members, make it final and use a Dispatch Queue and add operations to the queue

import SwiftUI
import Combine

actor SendableDBManager {
    func updateDB(name: UserInfo) {
        // some code here to update DB
    }
}

final class UserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.prajakta.queue")

    init(name: String) {
        self.name = name
    }

    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableViewModel:  ObservableObject {
    private var userInfo: UserInfo
    let manager = SendableDBManager()

    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }

    func updateCurrentUserInfo() async  {
        await manager.updateDB(name: UserInfo(name: "Gouri"))
    }
}

struct SendableExample: View {
    @StateObject private var vm = SendableViewModel(userInfo: UserInfo(name: "Prajakta"))

    var body: some View {
        Text("hello world")
            .task {
               await vm.updateCurrentUserInfo()
            }
    }
}

#Preview {
    SendableExample()
}
