//
//  MyCalendarApp.swift
//  MyCalendar
//
//  Created by Junghyun Lee on 7/23/25.
//

import SwiftUI

@main
struct MyCalendarApp: App {
  var body: some Scene {
    WindowGroup {
//      CustomCalendarView(selectedDate: .constant(Date()))
      CustomCalendarView()
    }
  }
}
