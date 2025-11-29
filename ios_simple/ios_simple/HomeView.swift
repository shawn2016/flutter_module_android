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
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("首页")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                // 进入 Flutter 按钮 - 使用 NavigationLink 打开全屏页面
                NavigationLink(destination: FlutterView()) {
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
                
                Spacer()
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Flutter 视图包装器
struct FlutterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        print("🔄 创建 FlutterViewController...")
        let flutterViewController = FlutterManager.shared.getFlutterViewController()
        
        // 确保视图正确加载
        flutterViewController.view.backgroundColor = .white
        
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

