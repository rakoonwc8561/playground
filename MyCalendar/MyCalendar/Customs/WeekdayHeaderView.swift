//
//  WeekdayHeaderView.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

/// 요일(일~토) 표시
struct WeekdayHeaderView: View {
  
  // MARK: - Properties
  
  private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
  
  // MARK: - Views
  
  var body: some View {
    HStack {
      ForEach(daysOfWeek, id: \.self) { day in
        Text(day)
          .font(.subheadline)
          .frame(maxWidth: .infinity)
          .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
      }
    }
  }
}
