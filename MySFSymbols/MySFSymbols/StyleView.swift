//
//  StyleView.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import SwiftUI

struct StyleView: View {
  var body: some View {
    HStack(spacing: 20) {
      VStack(spacing: 20) {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.yellow)  // 아이콘 전체가 노란색으로 칠해진다
      }
      
      VStack(spacing: 20) {
        // 단일 컬러도 가능
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.yellow)

        // 그라데이션
        let gradient = LinearGradient(
            gradient: Gradient(colors: [.red, .orange, .yellow]),
            startPoint: .top,
            endPoint: .bottom
        )
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(gradient)

        // Material (iOS 15+)
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.thickMaterial)
      }
    }
  }
}

#Preview {
  StyleView()
}
