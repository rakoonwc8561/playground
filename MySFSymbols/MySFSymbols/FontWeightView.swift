//
//  FontWeightView.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import SwiftUI

struct FontWeightView: View {
  var body: some View {
    VStack(spacing: 20) {
      // 폰트 크기 지정
      HStack {
        Image(systemName: "star.fill")
          .font(.system(size: 40))           // 고정 크기 40pt
        
        Image(systemName: "star.fill")
          .font(.title)                      // Dynamic Type Title 사이즈
        
        Image(systemName: "star.fill")
          .font(.largeTitle).foregroundColor(.yellow)
      }
      // 가중치 설정
      HStack {
        Image(systemName: "eraser")
          .font(.system(size: 36, weight: .light))
          .foregroundColor(.red)
        
        Image(systemName: "eraser")
          .font(.system(size: 36, weight: .bold))
          .foregroundColor(.red)
      }
      // 스케일 조정
      HStack{
        Image(systemName: "magnifyingglass")
          .imageScale(.small)
        Image(systemName: "magnifyingglass")
          .imageScale(.medium)
        Image(systemName: "magnifyingglass")
          .imageScale(.large)
      }
      
      // Variant
      HStack {
        Image(systemName: "heart")
          .symbolVariant(.circle)
          .font(.title)
        
        Image(systemName: "heart")
          .symbolVariant(.fill)
          .font(.title)
        
        Image(systemName: "heart")
          .symbolVariant(.slash)
          .font(.title)
      }
      .foregroundStyle(.red)
    }
  }
}

#Preview {
  FontWeightView()
}
