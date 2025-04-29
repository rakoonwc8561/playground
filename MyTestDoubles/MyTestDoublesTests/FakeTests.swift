//
//  FakeTests.swift
//  MyTestDoublesTests
//
//  Created by Junghyun Lee on 4/29/25.
//

import XCTest

@testable import MyTestDoubles

// 복잡한 HTTP 요청 로직은 제거했지만, 핵심 기능인
// 사료량 조회와 급여 로직은 포함되어있습니다.
final class FakePetFeeder: PetFeederService {
  private var foodLevel: Int
  
  /// 초기 사료량 설정
  init(initialFoodLevel: Int) {
    self.foodLevel = initialFoodLevel
  }
  
  func checkFoodLevel() -> Int {
    return foodLevel
  }
  
  func dispenseFood(units: Int) throws {
    let available = foodLevel
    guard available >= units else {
      throw PetFeederError.noFood
    }
    foodLevel -= units
  }
}

final class FakeTests: XCTestCase {
  func testFeed_succeedAndReducesFoodLevel() {
    let fakeFeeder = FakePetFeeder(initialFoodLevel: 10)
    let viewModel = PetFeederViewModel(feeder: fakeFeeder)
    
    // 5개 먹이 급여
    XCTAssertTrue(viewModel.feed(units: 5))
    // 5개 급여 후 남은 갯수 체크
    XCTAssertEqual(fakeFeeder.checkFoodLevel(), 5)
  }
  
  func testMultipleFeedings_reduceFoodSequentially() {
    let fakeFeeder = FakePetFeeder(initialFoodLevel: 6)
    let controller = PetFeederViewModel(feeder: fakeFeeder)
    
    XCTAssertTrue(controller.feed(units: 2))
    XCTAssertEqual(fakeFeeder.checkFoodLevel(), 4)
    
    XCTAssertTrue(controller.feed(units: 4))
    XCTAssertEqual(fakeFeeder.checkFoodLevel(), 0)
    
    // 더 이상 사료가 없으니 실패
    XCTAssertFalse(controller.feed(units: 1))
    XCTAssertEqual(fakeFeeder.checkFoodLevel(), 0)
  }
}
