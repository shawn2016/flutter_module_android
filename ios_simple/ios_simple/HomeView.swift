//
//  HomeView.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("首页")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                // 进入 Flutter 按钮
                Button(action: {
                    // TODO: 添加进入 Flutter 的事件
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
                
                Spacer()
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}

