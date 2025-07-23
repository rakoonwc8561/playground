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
import UIKit

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
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let yearRange = Array(1970...2100)
    
    var body: some View {
        VStack(spacing: 16) {
            // 상단: 월/연도 및 이동 버튼
            HStack {
                // 이전 달 이동
                Button(action: { animateMonthChange(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                // 년/월 텍스트 (탭 시 Picker 시트 표시)
                Button(action: {
                    pickerYear = calendar.component(.year, from: displayedDate)
                    pickerMonth = calendar.component(.month, from: displayedDate)
                    showMonthYearPicker = true
                }) {
                    Text(monthYearString(for: displayedDate))
                        .font(.headline)
                        .foregroundColor(.primary)
                        .underline()
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
                Spacer()
                // 다음 달 이동
                Button(action: { animateMonthChange(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            // 요일(일~토) 표시
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
                }
            }
            
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
        .padding()
    }
    
    // MARK: - Helper Functions
    
    /// yyyy년 M월 형태로 월/연도 문자열 반환
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
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

/// 년/월을 직접 선택할 수 있는 Picker 시트 뷰
struct MonthYearPickerView: View {
    @Binding var year: Int
    @Binding var month: Int
    let yearRange: [Int]
    var onSelect: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button("취소", action: onCancel)
                        .padding(.trailing)
                }
                HStack(spacing: 0) {
                    // 년도 선택 Picker
                    Picker("년도", selection: $year) {
                        ForEach(yearRange, id: \.self) { y in
                            Text("\(y)년").tag(y)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                    // 월 선택 Picker
                    Picker("월", selection: $month) {
                        ForEach(1...12, id: \.self) { m in
                            Text("\(m)월").tag(m)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 180)
                // 이동 버튼
                Button("이동") {
                    onSelect()
                }
                .font(.headline)
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

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

//// 배열을 2차원으로 쪼개는 확장 (이전 코드에서 사용, LazyVGrid로 대체 가능)
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        stride(from: 0, to: count, by: size).map {
//            Array(self[$0..<Swift.min($0 + size, count)])
//        }
//    }
//}

// Preview
#Preview {
    CustomCalendarView()
}
