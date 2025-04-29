//
//  MockTests.swift
//  MyTestDoublesTests
//
//  Created by Junghyun Lee on 4/29/25.
//

import XCTest

@testable import MyTestDoubles

// LunchSuggestionService를 흉내 내고, 호출 횟수와 반환값을 기억하는 Mock
final class MockLunchSuggestionService: LunchSuggestionService {
  // 호출 여부와 횟수 카운팅
  private(set) var callCount = 0
  
  var stubbedMenu: String = ""
  
  func getLunchSuggestion() -> String {
    callCount += 1
    return stubbedMenu
  }
}

final class MockTests: XCTestCase {
  func testLoadSuggestion_callOnlyOnce_andSetSuggesion() {
    // Mock 생성 및 반환값 지정
    let expectedMenu = "냉면"
    let mockService = MockLunchSuggestionService()
    mockService.stubbedMenu = expectedMenu
    
    // ViewModel에 Mock 주입
    let viewModel = LunchViewModel(service: mockService)
    
    // 초기 상태 검증
    XCTAssertEqual(mockService.callCount, 0)
    XCTAssertNil(viewModel.suggestion)
    
    // 수행
    viewModel.loadSuggestion()
    
    // 검증: getLunchSuggestion()이 한 번 호출 됐는지
    XCTAssertEqual(mockService.callCount, 1, "getLunchSuggestion()은 한 번만 호출되어야 합니다.")
    
    // 검증: 반환된 메뉴가 ViewModel에 잘 반영 되었는지
    XCTAssertEqual(viewModel.suggestion, expectedMenu)
  }
  
  func testLoadSuggestion_calledTwice_updatesCallCount() {
    // Mock 생성 및 반환값 지정
    let expectedMenu = "냉면"
    let mockService = MockLunchSuggestionService()
    mockService.stubbedMenu = expectedMenu
    
    // ViewModel에 Mock 주입
    let viewModel = LunchViewModel(service: mockService)
    
    // 두 번 호출
    viewModel.loadSuggestion()
    viewModel.loadSuggestion()
    
    XCTAssertEqual(mockService.callCount, 2, "loadSuggestion() 호출 횟수만큼 getLunchSuggestion()도 호출되어야 합니다.")
  }
}
