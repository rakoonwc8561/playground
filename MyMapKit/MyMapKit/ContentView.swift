//
//  ContentView.swift
//  MyMapKit
//
//  Created by Junghyun Lee on 7/15/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
  
  // MARK: - Properties
  
  @StateObject private var locationManager = LocationManager()
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )
  @State private var cameraPosition: MapCameraPosition =
    .region(
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )
    )
  @State private var selection: MapFeature? = nil
  
  // MARK: - Views
  
  var body: some View {
    Map(position: $cameraPosition, selection: $selection)
      .mapStyle(.standard(pointsOfInterest: .all))
      .mapControls {
        MapUserLocationButton()
      }
      .onChange(of: selection) { feature in
        guard let feature = feature else { return }
        region.center = feature.coordinate
        cameraPosition = .region(region)
      }
      .sheet(item: $selection) { feature in
        POIDetailView(feature: feature)
          .presentationDetents([.height(100), .height(200)])
          .presentationDragIndicator(.visible)
      }
  }
}
