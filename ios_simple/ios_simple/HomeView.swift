//
//  HomeView.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI
import UIKit
import Flutter

struct HomeView: View {
    @State private var showFlutter = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("首页")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                // 进入 Flutter 按钮 - 使用 fullScreenCover 全屏显示（类似 Android）
                Button(action: {
                    showFlutter = true
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                        Text("进入 Flutter")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .fullScreenCover(isPresented: $showFlutter) {
                    FlutterView()
                }
                
                Spacer()
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Flutter 视图包装器 - 全屏显示，无导航栏，无安全区域（与 Android 保持一致）
struct FlutterView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> FlutterViewController {
        print("🔄 创建 FlutterViewController...")
        let flutterViewController = FlutterManager.shared.getFlutterViewController()
        
        // 确保视图正确加载
        flutterViewController.view.backgroundColor = .white
        
        // ⭐ 隐藏导航栏（与 Android 保持一致）
        flutterViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // ⭐ 隐藏底部导航栏（如果有）
        flutterViewController.hidesBottomBarWhenPushed = true
        
        // ⭐ 设置为全屏显示
        flutterViewController.modalPresentationStyle = .fullScreen
        
        // ⭐ 覆盖安全区域，真正全屏显示（包括状态栏）
        if #available(iOS 11.0, *) {
            flutterViewController.view.insetsLayoutMarginsFromSafeArea = false
        }
        flutterViewController.edgesForExtendedLayout = .all
        flutterViewController.extendedLayoutIncludesOpaqueBars = true
        
        // ⭐ 隐藏状态栏（可选，如果需要完全全屏）
        // flutterViewController.setNeedsStatusBarAppearanceUpdate()
        
        // 优化焦点处理，减少警告
        if #available(iOS 15.0, *) {
            // iOS 15+ 可以设置焦点相关属性
            flutterViewController.view.setNeedsFocusUpdate()
        }
        
        print("✅ FlutterViewController 创建完成")
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {
        // 不需要更新
    }
}

#Preview {
    HomeView()
}

