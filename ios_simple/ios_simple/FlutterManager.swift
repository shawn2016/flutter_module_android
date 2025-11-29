//
//  FlutterManager.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import Foundation
import Flutter
import UIKit

class FlutterManager {
    static let shared = FlutterManager()
    
    // 从 AppDelegate 获取 FlutterEngine
    private var flutterEngine: FlutterEngine? {
        // 使用全局变量 AppDelegate.shared
        return AppDelegate.shared?.flutterEngine
    }
    
    private init() {
        // FlutterEngine 在 AppDelegate 中初始化
    }
    
    func getFlutterViewController(initialRoute: String? = nil) -> FlutterViewController {
        // 确保 FlutterEngine 已初始化
        guard let engine = flutterEngine else {
            print("⚠️ FlutterEngine 未找到，创建新的引擎")
            // 如果获取失败，尝试直接创建新的引擎
            let newEngine = FlutterEngine(name: "fallback flutter engine")
            newEngine.run()
            
            // 注册插件
            if let registrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
                if registrantClass.responds(to: Selector(("registerWithRegistry:"))) {
                    registrantClass.perform(Selector(("registerWithRegistry:")), with: newEngine)
                }
            }
            
            let flutterViewController = FlutterViewController(
                engine: newEngine,
                nibName: nil,
                bundle: nil
            )
            
            if let route = initialRoute {
                flutterViewController.setInitialRoute(route)
            }
            
            return flutterViewController
        }
        
        print("✅ 使用已初始化的 FlutterEngine")
        
        // 创建 FlutterViewController
        let flutterViewController = FlutterViewController(
            engine: engine,
            nibName: nil,
            bundle: nil
        )
        
        // 设置初始路由（如果提供）
        if let route = initialRoute {
            flutterViewController.setInitialRoute(route)
        }
        
        return flutterViewController
    }
}
