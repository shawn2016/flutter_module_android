//
//  OrderView.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("订单")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("暂无订单")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .navigationTitle("订单")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OrderView()
}


