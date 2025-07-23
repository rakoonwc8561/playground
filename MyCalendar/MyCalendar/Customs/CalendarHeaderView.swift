//
//  CalendarHeaderView.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

/// 상단 월/연도 및 이동 버튼을 가진 헤더
struct CalendarHeaderView: View {
  
  // MARK: - Properties
  
  @Binding var displayedDate: Date
  let onPrevMonth: () -> Void
  let onSelectMonthYear: () -> Void
  let onNextMonth: () -> Void
  
  // MARK: - Views
  
  var body: some View {
    HStack {
      prevMonthButton
      Spacer()
      monthYearSelector
      Spacer()
      nextMonthButton
    }
    .padding(.horizontal)
  }
  
  private var monthYearSelector: some View {
    Button {
      onSelectMonthYear()
    } label: {
      Text(monthYearString(for: displayedDate))
        .font(.headline)
        .foregroundColor(.primary)
        .underline()
    }
  }
  
  // MARK: - Control buttons
  
  /// 이전 달 이동
  private var prevMonthButton: some View {
    Button {
      onPrevMonth()
    } label: {
      Image(systemName: "chevron.left")
    }
  }
  
  /// 다음 달 이동
  private var nextMonthButton: some View {
    Button {
      onNextMonth()
    } label: {
      Image(systemName: "chevron.right")
    }
  }
}

// MARK: - Helpers

private extension CalendarHeaderView {
  /// yyyy년 M월 형태로 월/연도 문자열 반환
  func monthYearString(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월"
    return formatter.string(from: date)
  }
}
