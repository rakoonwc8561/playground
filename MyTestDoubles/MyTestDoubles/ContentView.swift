//
//  ContentView.swift
//  MyTestDoubles
//
//  Created by Junghyun Lee on 4/29/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("My test doubles")
    }
    .padding()
    .task {
      // Stub
//      let service = MyLunchSuggestionService()
//      let viewModel = LunchViewModel(service: service)
//      viewModel.loadSuggestion()
      
      // Dummy
//      let logger = MyLogger()
//      let service = OrderService(logger: logger)
//      let price = service.calculateTotal(prices: [100.0, 200.0])
    }
  }
}

#Preview {
  ContentView()
}
