//
//  ContentView.swift
//  MyLoopingVideoBackground
//
//  Created by Junghyun Lee on 5/6/25.
//

import AVKit
import SwiftUI

struct ContentView: View {
  let buttons: [(title: String, tint: Color, text: Color)] = [
    ("카카오로 시작하기", .yellow, .black),
    ("네이버로 시작하기", .green, .white),
    ("애플로 시작하기", .black, .white)
  ]
  
  var body: some View {
    VideoBackgroundView {
      VStack(spacing: 10) {
        Spacer()
        
        ForEach(buttons, id: \.title) { button in
          SocialLoginButton(
            title: button.title,
            tintColor: button.tint,
            textColor: button.text
          ) {
            print("\(button.title) tapped")
          }
        }
        
        Text("계정을 잊으셨나요?")
          .font(.system(size: 15))
          .foregroundColor(.white.opacity(0.7))
      }
      .padding(.bottom, 20)
    }
  }
}

struct VideoBackgroundView<Content: View>: View {
  @Environment(\.scenePhase) private var scenePhase
  private let loopingPlayer = LoopingPlayer(videoName: "winter")
  let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    GeometryReader { proxy in
      // 1) VideoPlayer를 전체 화면에 깔기
      VideoPlayer(player: loopingPlayer.player)
        .aspectRatio(contentMode: .fill)
        .frame(width: proxy.size.width, height: proxy.size.height)
        .allowsHitTesting(false)
        .onAppear {
          configureAudioSessionForBackgroundVideo()
          loopingPlayer.player.play()    // 화면에 나타나면 재생 시작
        }
        .onChange(of: scenePhase) { newPhase in
          switch newPhase {
          case .active:
            // 앱이 포그라운드로 돌아올 때 재생 재개
            loopingPlayer.player.play()
          case .background, .inactive:
            // (선택) 백그라운드에선 일시정지 할 수도 있고, 그대로 두어도 됨
            break
          @unknown default:
            break
          }
        }
      
      LinearGradient(
        gradient: Gradient(colors: [
          Color.black.opacity(0.0),
          Color.black.opacity(0.4),
          Color.black.opacity(0.8),
          Color.black.opacity(1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      
      // 2) 앞쪽에 올 UI
      content()
        .padding()
    }
    .ignoresSafeArea()
  }
  
  func configureAudioSessionForBackgroundVideo() {
    do {
      // .ambient: 무음일 땐 벨소리에 따르고, 재생 중인 다른 앱 음악을 중지시키지 않음
      // mixWithOthers: 다른 백그라운드 오디오와 섞어 재생 허용
      try AVAudioSession.sharedInstance().setCategory(
        .ambient,
        mode: .default,
        options: [.mixWithOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("🔊 오디오 세션 설정 오류:", error)
    }
  }
}

struct SocialLoginButton: View {
  let title: String
  let tintColor: Color
  let textColor: Color
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 15, weight: .semibold))
        .frame(maxWidth: .infinity)
        .frame(height: 35)
    }
    .buttonStyle(.borderedProminent)
    .tint(tintColor)
    .foregroundStyle(textColor)
  }
}

#Preview {
  ContentView()
}
