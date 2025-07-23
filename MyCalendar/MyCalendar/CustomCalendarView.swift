//
//  CustomCalendarView.swift
//  MyCalendar
//
//  커스텀 캘린더 작성하기 - 블로그 포스팅 예제 코드
//  SwiftUI로 iOS 스타일의 달력 UI를 직접 구현하는 방법을 소개합니다.
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

/// 메인 커스텀 캘린더 뷰
struct CustomCalendarView: View {
  // 현재 표시 중인 달(월 단위)
  @State private var displayedDate = Date()
  // 사용자가 선택한 날짜
  @State private var selectedDate: Date? = nil
  // 스와이프 제스처 상태
  @GestureState private var dragOffset: CGFloat = 0
  // 달력 전환 애니메이션 트랜지션
  @State private var calendarTransition: AnyTransition = .identity
  // 년/월 선택 시트 표시 여부
  @State private var showMonthYearPicker = false
  // Picker에서 선택 중인 년/월
  @State private var pickerYear = Calendar.current.component(.year, from: Date())
  @State private var pickerMonth = Calendar.current.component(.month, from: Date())
  
  // 캘린더, 요일, 연도 범위 등 상수
  private let calendar = Calendar.current
  private let yearRange = Array(1970...2100)
  
  var body: some View {
    VStack(spacing: 16) {
      CalendarHeaderView(
        displayedDate: $displayedDate,
        onPrevMonth: { animateMonthChange(by: -1) },
        onSelectMonthYear: {
          pickerYear = calendar.component(.year, from: displayedDate)
          pickerMonth = calendar.component(.month, from: displayedDate)
          showMonthYearPicker = true
        },
        onNextMonth: { animateMonthChange(by: 1) }
      )
  
      WeekdayHeaderView()
      
      // 달력 날짜 그리드 (슬라이드 애니메이션 적용)
      ZStack {
        CalendarMonthView(
          displayedDate: displayedDate,
          selectedDate: $selectedDate,
          calendar: calendar
        )
        .id(displayedDate) // 달이 바뀔 때마다 뷰 갱신
        .transition(calendarTransition)
        .animation(.easeInOut(duration: 0.18), value: displayedDate)
      }
      // 좌우 스와이프 제스처로 월 전환
      .gesture(
        DragGesture()
          .updating($dragOffset) { value, state, _ in
            state = value.translation.width
          }
          .onEnded { value in
            if value.translation.width < -50 {
              animateMonthChange(by: 1)
            } else if value.translation.width > 50 {
              animateMonthChange(by: -1)
            }
          }
      )
      
      // 오늘로 이동 버튼 (이번 달이면 비활성화)
      let isCurrentMonth = calendar.isDate(displayedDate, equalTo: Date(), toGranularity: .month)
      Button(action: { displayedDate = Date() }) {
        Text("오늘로 이동")
          .font(.footnote)
          .padding(6)
          .background(isCurrentMonth ? Color(.systemGray5) : Color(.systemGray6))
          .foregroundColor(isCurrentMonth ? Color.gray : Color.primary)
          .cornerRadius(8)
      }
      .disabled(isCurrentMonth)
      .padding(.top, 8)
    }
    // 년/월 직접 선택 시트
    .sheet(isPresented: $showMonthYearPicker) {
      MonthYearPickerView(
        year: $pickerYear,
        month: $pickerMonth,
        yearRange: yearRange,
        onSelect: {
          // Picker에서 선택 후 해당 달로 이동
          if let newDate = calendar.date(from: DateComponents(year: pickerYear, month: pickerMonth, day: 1)) {
            displayedDate = newDate
          }
          showMonthYearPicker = false
        },
        onCancel: {
          showMonthYearPicker = false
        }
      )
    }
    .padding()
  }
  
  // MARK: - Helper Functions
  
  /// 월 전환(버튼/스와이프) 시 애니메이션 및 햅틱 피드백 적용
  private func animateMonthChange(by value: Int) {
    // 방향에 따라 트랜지션 설정 (좌/우 슬라이드)
    calendarTransition = value > 0 ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)) : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    // 햅틱 피드백 (실기기에서만 동작)
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
    withAnimation {
      if let newDate = calendar.date(byAdding: .month, value: value, to: displayedDate) {
        displayedDate = newDate
      }
    }
  }
}
