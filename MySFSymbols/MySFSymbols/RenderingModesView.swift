//
//  RenderingModesView.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import SwiftUI

/*
 static let hierarchical: SymbolRenderingMode
 A mode that renders symbols as multiple layers, with different opacities applied to the
 foreground style.
 
 static let monochrome: SymbolRenderingMode
 A mode that renders symbols as a single layer filled with the foreground style.
 
 static let multicolor: SymbolRenderingMode
 A mode that renders symbols as multiple layers with their inherit styles.
 
 static let palette: SymbolRenderingMode
 A mode that renders symbols as multiple layers, with different styles applied to the layers.
 */

enum RenderingItem: String {
  case hierarchical, monochrome, multicolor, palette
}

struct RenderingModesView: View {
  var body: some View {
    VStack {
      HStack {
        RenderingItemView(mode: .hierarchical)
        RenderingItemView(mode: .monochrome)
      }
      HStack {
        RenderingItemView(mode: .multicolor)
        RenderingItemView(mode: .palette)
      }
    }
    .padding()
    .navigationTitle("렌더링 모드")
  }
}

private extension RenderingModesView {
  struct RenderingItemView: View {
    let mode: RenderingItem
    private let imageName = "exclamationmark.triangle.fill"
    
    var body: some View {
      VStack(spacing: 20) {
        switch mode {
        case .hierarchical:
          Image(systemName: imageName)
            .symbolRenderingMode(.hierarchical)
            .resizable()
            .aspectRatio(contentMode: .fit)
//            .foregroundStyle(.pink)
        case .monochrome:
          Image(systemName: imageName)
            .symbolRenderingMode(.monochrome)
            .resizable()
            .aspectRatio(contentMode: .fit)
//            .foregroundStyle(.pink)
        case .multicolor:
          Image(systemName: imageName)
            .symbolRenderingMode(.multicolor)
            .resizable()
            .aspectRatio(contentMode: .fit)
        case .palette:
          Image(systemName: imageName)
            .symbolRenderingMode(.palette)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.red, Color.cyan)
        }
        
        Text(mode.rawValue)
          .font(.title)
      }
    }
  }
}

#Preview {
  RenderingModesView()
}
