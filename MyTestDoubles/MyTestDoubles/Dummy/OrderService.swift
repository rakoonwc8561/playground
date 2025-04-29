//
//  Logger.swift
//  MyTestDoubles
//
//  Created by Junghyun Lee on 4/29/25.
//

import Foundation

// 1. Logger 프로토콜 정의
protocol Logger {
  func log(_ message: String)
}

// 2. 실제 프로덕션 코드용 Logger
final class MyLogger: Logger {
  func log(_ message: String) {
    print("로그: \(message)")
  }
}

// 3. OrderService - 생성자에서 반드시 Logger를 받고 있다.
final class OrderService {
  private let logger: Logger
  
  init(logger: Logger) {
    self.logger = logger
  }
  
  func calculateTotal(prices: [Double]) -> Double {
    let total = prices.reduce(0, +)
    logger.log("총 가격은 \(total) 입니다.")
    return total
  }
}
