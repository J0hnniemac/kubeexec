//
//  kubeexecApp.swift
//  kubeexec
//
//  Created by John McManus on 21/10/2021.
//

import SwiftUI

@main
struct kubeexecApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
