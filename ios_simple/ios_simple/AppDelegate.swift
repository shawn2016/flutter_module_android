//
//  AppDelegate.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import UIKit
import Flutter

class AppDelegate: UIResponder, UIApplicationDelegate {
    // 全局变量来存储 AppDelegate 实例
    static weak var shared: AppDelegate?
    
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 启动 Flutter 引擎
        flutterEngine.run()
        
        // 注册 Flutter 插件（如果可用）
        if let registrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
            if registrantClass.responds(to: Selector(("registerWithRegistry:"))) {
                registrantClass.perform(Selector(("registerWithRegistry:")), with: flutterEngine)
            }
        }
        
        return true
    }
}
