//
//  LunchSuggestionService.swift
//  MyTestDoubles
//
//  Created by Junghyun Lee on 4/29/25.
//

import Foundation

// 점심 메뉴를 추천해주는 프로토콜 정의
protocol LunchSuggestionService {
  func getLunchSuggestion() -> String
}

// 원격 API를 통해서 받아온다고 가정
final class MyLunchSuggestionService: LunchSuggestionService {
  private let menus = ["김치찌개", "비빔밥", "돈까스", "파스타", "햄버거"]
  
  func getLunchSuggestion() -> String {
    /*
     실제로는 API를 호출하는 복잡한 로직이 들어가겠지만,
     예제에서는 간단하게 랜덤 음식을 리턴
    */
    return menus.randomElement()!
  }
}

// 뷰모델 생성
final class LunchViewModel {
  private let service: LunchSuggestionService
  
  /// 화면 바인딩용 프로퍼티
  private(set) var suggestion: String?
  
  init(service: LunchSuggestionService) {
    self.service = service
  }
  
  func loadSuggestion() {
    let menu = service.getLunchSuggestion()
    suggestion = menu
  }
}
