//
//  MapFeature+Extension.swift
//  MyMapKit
//
//  Created by Junghyun Lee on 7/15/25.
//

import MapKit
import SwiftUI

extension MapFeature: @retroactive Identifiable {
  public var id: String {
    // 위도·경도와 (옵션인) title을 합쳐 유니크한 문자열로 만듭니다
    let titlePart = title ?? ""
    return "\(coordinate.latitude),\(coordinate.longitude)-\(titlePart)"
  }
}
