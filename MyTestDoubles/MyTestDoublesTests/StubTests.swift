//
//  StubTests.swift
//  MyTestDoublesTests
//
//  Created by Junghyun Lee on 4/29/25.
//

import XCTest

@testable import MyTestDoubles

// 테스트 시점에 원하는 메뉴를 고정해서 리턴하도록 만듭니다.
final class LunchSuggestionServiceStub: LunchSuggestionService {
  private let stubbedMenu: String
  
  init(stubbedMenu: String) {
    self.stubbedMenu = stubbedMenu
  }
  
  func getLunchSuggestion() -> String {
    return stubbedMenu
  }
}

final class StubTests: XCTestCase {
  func testSuggestion_initiallyNil() {
    let stub = LunchSuggestionServiceStub(stubbedMenu: "불고기")
    let viewModel = LunchViewModel(service: stub)
    
    XCTAssertNil(viewModel.suggestion, "아직 loadSuggestion()을 호출하지 않아 suggesion은 nil어야 합니다.")
  }
  
  func testLoadSuggestion_returnStubbedMenu() {
    let expectedMenu = "치즈김밥"
    let stub = LunchSuggestionServiceStub(stubbedMenu: expectedMenu)
    let viewModel = LunchViewModel(service: stub)
    
    viewModel.loadSuggestion()
    
    XCTAssertEqual(viewModel.suggestion, expectedMenu, "Stub으로 지정한 메뉴가 ViewModel에 잘 반영되어야 합니다.")
  }
}
