//
//  MusicPlayerService.swift
//  MyTestDoubles
//
//  Created by Junghyun Lee on 4/29/25.
//

import Foundation
import AVFoundation

// 음악 플레이어를 위한 간단한 인터페이스
protocol MusicPlayerService {
  func play(trackID: String)
  func pause()
}

final class RealPlayer: MusicPlayerService {
  private var audioPlayer: AVAudioPlayer?
  
  /// trackID ⇔ 번들 내 파일 이름 매핑 테이블
  /// 실제 앱에서는 서버에서 URL을 받아온다거나, 파일 관리 로직을 따로 분리하는 게 좋습니다.
  private let trackMap: [String: URL?] = [
    "track_123": Bundle.main.url(forResource: "track_123", withExtension: "mp3"),
    "track_abc": Bundle.main.url(forResource: "track_abc", withExtension: "wav")
    // 필요한 트랙ID ↔ 파일 URL을 여기에 추가
  ]
  
  func play(trackID: String) {
    guard let url = trackMap[trackID] as? URL else {
      print("⚠️ RealPlayer Error: Track '\(trackID)' not found in bundle.")
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
      print("▶️ Playing track: \(trackID)")
    } catch {
      print("❌ RealPlayer Error: Failed to play '\(trackID)' — \(error)")
    }
  }
  
  func pause() {
    guard let player = audioPlayer, player.isPlaying else {
      print("⚠️ RealPlayer Warning: No track is currently playing.")
      return
    }
    player.pause()
    print("⏸ Paused playback")
  }
}

// 뮤직 플레이어를 재생, 정지하고 마지막 액션을 기록해두는 ViewModel
final class MusicPlayerViewModel {
  private let player: MusicPlayerService
  
  private(set) var lastAction: String?
  
  init(player: MusicPlayerService) {
    self.player = player
  }
  
  func playTrack(id: String) {
    player.play(trackID: id)
    lastAction = "played:\(id)"
  }
  
  func pauseTrack() {
    player.pause()
    lastAction = "paused"
  }
}
