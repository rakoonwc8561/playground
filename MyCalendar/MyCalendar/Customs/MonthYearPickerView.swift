//
//  MonthYearPickerView.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

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
