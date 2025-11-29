//
//  ios_simpleApp.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI

@main
struct ios_simpleApp: App {
    // 使用 UIApplicationDelegateAdaptor 连接 AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
