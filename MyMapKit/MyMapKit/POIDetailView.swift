//
//  POIDetailView.swift
//  MyMapKit
//
//  Created by Junghyun Lee on 7/15/25.
//

import MapKit
import SwiftUI

struct POIDetailView: View {
  
  // MARK: - Properties
  
  let feature: MapFeature
  
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
