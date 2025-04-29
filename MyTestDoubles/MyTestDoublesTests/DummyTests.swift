//
//  DummyTests.swift
//  MyTestDoublesTests
//
//  Created by Junghyun Lee on 4/29/25.
//

import XCTest

@testable import MyTestDoubles

final class DummyLogger: Logger {
  func log(_ message: String) {
    // DummyLogger에서는 아무런 동작도 하지 않는다.
  }
}

final class DummyTests: XCTestCase {
  func testCalculateTotal_withDummyLogger_returnsCorrectSub() {
    let service = OrderService(logger: DummyLogger())
    let prices: [Double] = [10, 20, 30]
    let result = service.calculateTotal(prices: prices)
    XCTAssertEqual(result, 60, "result는 prices의 모든 값을 더한 값과 같아야 합니다.")
  }
}
