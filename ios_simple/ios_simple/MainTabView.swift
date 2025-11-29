//
//  MainTabView.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            OrderView()
                .tabItem {
                    Label("订单", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}

