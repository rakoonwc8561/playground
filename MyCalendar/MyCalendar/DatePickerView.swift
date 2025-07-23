//
//  DatePickerView.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

struct DatePickerView: View {
  
  // MARK: - Properties
  
  @State private var date = Date()
  
  // MARK: - Views
  
  var body: some View {
    DatePicker(
      "감상한 날짜",
      selection: $date,
      displayedComponents: [.date]
    )
    .datePickerStyle(.graphical)
  }
}

#Preview {
  DatePickerView()
}
