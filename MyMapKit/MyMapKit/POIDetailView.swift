//
//  POIDetailView.swift
//  MyMapKit
//
//  Created by Junghyun Lee on 7/15/25.
//

import MapKit
import SwiftUI

// 1. 기본 MapFeature에서 받아올 수 있는 정보들 정리

struct POIDetailView: View {
  
  // MARK: - Properties
  
  let feature: MapFeature
  @ObservedObject var locationManager: LocationManager
  
  // MARK: - Views
  
  var body: some View {
    Text("Hello, World!")
  }
}

/*
 struct POIDetailSheet: View {
   let feature: MapFeature
   
   var body: some View {
     VStack(spacing: 16) {
       Text(feature.title ?? "이름 없음")
         .font(.title2)
         .bold()
       
       Text("위치: \(String(format: "%.4f", feature.coordinate.latitude)), "
            + "\(String(format: "%.4f", feature.coordinate.longitude))")
       .font(.caption)
       
       Spacer()
     }
     .padding()
   }
 }
 */
