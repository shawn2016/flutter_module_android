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
                // ⭐ 隐藏状态栏（可选，如果需要完全全屏）
                // .statusBar(hidden: true)
        }
    }
}
