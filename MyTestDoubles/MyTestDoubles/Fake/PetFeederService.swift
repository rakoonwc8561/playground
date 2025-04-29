//
//  PetFeederService.swift
//  MyTestDoubles
//
//  Created by Junghyun Lee on 4/29/25.
//

import Foundation

// 반려동물에게 사료를 공급하는 서비스 프로토콜
protocol PetFeederService {
  // 현재 남아있는 사료 갯수 조회
  func checkFoodLevel() -> Int
  // 지정한 갯수만큼 먹이를 주고, 부족하면 에러 발생
  func dispenseFood(units: Int) throws
}

enum PetFeederError: Error {
  case noFood
}

// 예를들어 실제 IoT 디바이스와 연결해서 먹이를 주는 로직이 있다고 가정
final class IoTPetFeederService: PetFeederService {
  private let baseURL: URL
  private let session: URLSession
  
  init(baseURL: URL, session: URLSession = .shared) {
    self.baseURL = baseURL
    self.session = session
  }
  
  func checkFoodLevel() -> Int {
    // 동기 호출 예시 (실제론 async/await로 바꾸는 게 좋음)
    let url = baseURL.appendingPathComponent("/foodLevel")
    let sem = DispatchSemaphore(value: 0)
    var level: Int = 0
    
    session.dataTask(with: url) { data, _, _ in
      if let data = data,
         let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
         let v = json["level"] as? Int {
        level = v
      }
      sem.signal()
    }.resume()
    
    sem.wait()
    return level
  }
  
  func dispenseFood(units: Int) throws {
    let url = baseURL.appendingPathComponent("/dispense")
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.httpBody = try JSONSerialization.data(withJSONObject: ["units": units])
    let sem = DispatchSemaphore(value: 0)
    var dispenseError: Error?
    
    session.dataTask(with: req) { data, resp, error in
      if let error = error {
        dispenseError = error
      } else if let http = resp as? HTTPURLResponse, http.statusCode != 200 {
        dispenseError = PetFeederError.noFood
      }
      sem.signal()
    }.resume()
    
    sem.wait()
    if let error = dispenseError {
      throw error
    }
  }
}

// PetFeederService를 사용해 사료를 주는 ViewModel
final class PetFeederViewModel {
  private let feeder: PetFeederService
  
  init(feeder: PetFeederService) {
    self.feeder = feeder
  }
  
  // 성공(true), 실패(false) 먹이 부족
  func feed(units: Int) -> Bool {
    let available = feeder.checkFoodLevel()
    guard available >= units else {
      return false
    }
    do {
      try feeder.dispenseFood(units: units)
      return true
    } catch {
      return false
    }
  }
}
