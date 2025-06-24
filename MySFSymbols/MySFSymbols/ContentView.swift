//
//  ContentView.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      List(ExampleType.allCases, id: \.self) { type in
        NavigationLink(type.title) {
          switch type {
          case .renderingMode:
            RenderingModesView()
          case .style:
            StyleView()
          case .fontWeight:
            FontWeightView()
          case .animation:
            SymbolAnimationView()
          }
        }
      }
      .navigationTitle("SF Symbols")
    }
  }
}

#Preview {
  ContentView()
}
