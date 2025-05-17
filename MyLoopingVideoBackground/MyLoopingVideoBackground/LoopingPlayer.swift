//
//  LoopingPlayer.swift
//  MyLoopingVideoBackground
//
//  Created by Junghyun Lee on 5/17/25.
//

import AVFoundation
import Foundation

final class LoopingPlayer {
  let player: AVQueuePlayer
  private var looper: AVPlayerLooper?
  
  init(videoName: String, videoType: String = "mp4") {
    // 1) 로컬 번들 혹은 URL로 AVPlayerItem 생성
    guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
      fatalError("비디오 파일을 찾을 수 없습니다.")
    }
    let asset = AVAsset(url: url)
    let item = AVPlayerItem(asset: asset)
    
    // 2) AVQueuePlayer + looper
    self.player = AVQueuePlayer()
    self.looper = AVPlayerLooper(player: player, templateItem: item)
    
    // 3) 사운드 제거
    player.isMuted = true
    // 4) 자동 재생 방지 정책 해제
    player.actionAtItemEnd = .none
  }
}
