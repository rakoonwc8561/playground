//
//  ExampleType.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import Foundation

enum ExampleType: CaseIterable {
  case renderingMode
  case style
  case fontWeight
  case animation
  
  var title: String {
    switch self {
    case .renderingMode:
      return "렌더링 모드"
    case .style:
      return "색상 및 스타일링"
    case .fontWeight:
      return "크기 및 가중치"
    case .animation:
      return "애니메이션"
    }
  }
}
