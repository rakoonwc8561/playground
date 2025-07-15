//
//  LocationManager.swift
//  MyMapKit
//
//  Created by Junghyun Lee on 7/15/25.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, ObservableObject {
  
  // MARK: - Properties
  
  private let locationManager = CLLocationManager()
  @Published var coordinate: CLLocationCoordinate2D?
  
  // MARK: - Initialize
  
  override init() {
    super.init()
    locationManager.delegate = self
    // 권한 요청
    locationManager.requestWhenInUseAuthorization() // 권한 요청하기
    locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치 데이터의 정확도
    locationManager.startUpdatingLocation() // 업데이트 시작
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    coordinate = location.coordinate
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print(error.localizedDescription)
  }
}
