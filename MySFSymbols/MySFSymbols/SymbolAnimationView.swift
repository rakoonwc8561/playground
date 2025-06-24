//
//  SymbolAnimationView.swift
//  MySFSymbols
//
//  Created by Junghyun Lee on 6/24/25.
//

import SwiftUI

struct SymbolAnimationView: View {
  @State private var trigger = 0
  @State private var isActive = false
  
  
  var body: some View {
    //    VStack(spacing: 30) {
    //      HStack {
    //        // Bounce
    //        VStack {
    //          Image(systemName: "heart.fill")
    //            .font(.system(size: 60))
    //            .aspectRatio(contentMode: .fit)
    //            .symbolEffect(.bounce, value: trigger)
    //            .foregroundStyle(.red)
    //          Text("bounce")
    //            .font(.system(size: 16, weight: .bold))
    //            .frame(maxWidth: .infinity)
    //        }
    //        // Pulse
    //        VStack {
    //          Image(systemName: "heart.fill")
    //            .font(.system(size: 60))
    //            .aspectRatio(contentMode: .fit)
    //            .symbolEffect(.pulse, value: trigger)
    //            .foregroundStyle(.red)
    //          Text("pulse")
    //            .font(.system(size: 16, weight: .bold))
    //            .frame(maxWidth: .infinity)
    //        }
    //        // Variable Color
    //        VStack {
    //          Image(systemName: "heart.fill")
    //            .font(.system(size: 60))
    //            .aspectRatio(contentMode: .fit)
    //            .symbolEffect(.variableColor, value: trigger)
    //            .foregroundStyle(.red)
    //          Text("variableColor")
    //            .font(.system(size: 16, weight: .bold))
    //            .frame(maxWidth: .infinity)
    //        }
    //      }
    //      Stepper("실행: \(trigger)", value: $trigger)
    //        .padding(.top, 20)
    //    }
    //    .padding()
    
    VStack(spacing: 30) {
      HStack(spacing: 20) {
        // Variable Color (iterative + reversing)
        VStack {
          Image(systemName: "antenna.radiowaves.left.and.right")
            .font(.system(size: 60))
            .symbolEffect(.variableColor.iterative.reversing, isActive: isActive)
        }
        // Pulse
        VStack {
          Image(systemName: "bell.fill")
            .font(.system(size: 60))
            .symbolEffect(.pulse, isActive: isActive)
        }
      }
      Toggle("isActive", isOn: $isActive)
        .padding(.top, 20)
    }
    .padding()
  }
}

#Preview {
  SymbolAnimationView()
}
