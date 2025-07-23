//
//  CalendarMonthView.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

/// 달력 한 달을 그리는 뷰 (날짜 그리드)
struct CalendarMonthView: View {
  let displayedDate: Date
  @Binding var selectedDate: Date?
  let calendar: Calendar
  
  var body: some View {
    let days = generateDaysWithAdjacent(for: displayedDate)
    // iOS 14+ LazyVGrid로 7열 달력 격자 구현
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    LazyVGrid(columns: columns, spacing: 8) {
      ForEach(days, id: \.self) { date in
        dayCell(for: date)
      }
    }
  }
  
  /// 해당 월을 6주(42칸)로, 앞뒤 빈칸은 이전/다음 달 날짜로 채움
  private func generateDaysWithAdjacent(for date: Date) -> [Date] {
    guard let monthInterval = calendar.dateInterval(of: .month, for: date),
          let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
      return []
    }
    var days: [Date] = []
    // 앞쪽: 이전 달 날짜 채우기
    if let prevMonth = calendar.date(byAdding: .month, value: -1, to: date),
       let prevMonthInterval = calendar.dateInterval(of: .month, for: prevMonth) {
      let prevMonthDays = calendar.range(of: .day, in: .month, for: prevMonth)!.count
      for i in stride(from: firstWeekday-2, through: 0, by: -1) {
        if let day = calendar.date(bySetting: .day, value: prevMonthDays - i, of: prevMonth) {
          days.append(day)
        }
      }
    }
    // 현재 달 날짜
    var current = monthInterval.start
    while current < monthInterval.end {
      days.append(current)
      guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
      current = next
    }
    // 뒤쪽: 다음 달 날짜 채우기
    let total = days.count
    let remain = (total % 7 == 0) ? 0 : (7 - total % 7)
    if remain > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) {
      for i in 1...remain {
        if let day = calendar.date(bySetting: .day, value: i, of: nextMonth) {
          days.append(day)
        }
      }
    }
    // 6주(42칸)로 맞추기 위해 추가
    while days.count < 42, let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) {
      let dayNum = days.count - total + 1
      if let day = calendar.date(bySetting: .day, value: dayNum, of: nextMonth) {
        days.append(day)
      }
    }
    return days
  }
  
  /// 날짜 셀: 오늘, 선택, 현재달/이전달/다음달 구분, 애니메이션 효과 등
  @ViewBuilder
  private func dayCell(for date: Date) -> some View {
    let isToday = calendar.isDateInToday(date)
    let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
    let isCurrentMonth = calendar.isDate(date, equalTo: displayedDate, toGranularity: .month)
    
    Button(action: {
      // 날짜 선택 시 spring 애니메이션 적용
      withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 0.5)) {
        selectedDate = date
      }
    }) {
      Text("\(calendar.component(.day, from: date))")
        .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36)
        .background(
          ZStack {
            if isSelected {
              // 선택된 날짜: 파란색 원 + 애니메이션
              Circle()
                .fill(Color.blue.opacity(0.8))
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 0.5), value: isSelected)
            } else if isToday {
              // 오늘: 빨간 테두리 원
              Circle().stroke(Color.red, lineWidth: 2)
            }
          }
        )
        .foregroundColor(
          isCurrentMonth ? (isSelected ? .white : (isToday ? .red : .primary)) : Color.gray.opacity(0.4)
        )
    }
    .buttonStyle(PlainButtonStyle())
  }
}
