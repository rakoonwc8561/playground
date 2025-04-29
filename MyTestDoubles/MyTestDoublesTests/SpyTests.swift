//
//  SpyTests.swift
//  MyTestDoublesTests
//
//  Created by Junghyun Lee on 4/29/25.
//

import XCTest

@testable import MyTestDoubles

// 실제 로직 위임 여부를 선택할 수 있는 Spy
// 호출 횟수, 파라미터, 호출 순서를 기록한다.
final class MusicPlayerServiceSpy: MusicPlayerService {
  private let wrappedService: MusicPlayerService
  
  // 기록용 프로퍼티
  private(set) var playCallCount = 0
  private(set) var pauseCallCount = 0
  private(set) var playedTrackIDs: [String] = []
  private(set) var callOrder: [String] = []
  
  init(wrapping service: MusicPlayerService) {
    self.wrappedService = service
  }
  
  func play(trackID: String) {
    playCallCount += 1
    playedTrackIDs.append(trackID)
    callOrder.append("play")
    
    wrappedService.play(trackID: trackID) // 실제 프로덕션 용 service 호출
  }
  
  func pause() {
    pauseCallCount += 1
    callOrder.append("pause")
    
    wrappedService.pause() // 실제 프로덕션 용 service 호출
  }
}

final class SpyTests: XCTestCase {
  func testPlayTrack_invokesPlayOnceWithCorrectID() {
    let realService = RealPlayer() // 실제 개발할 때 사용하는 RealPlayer를 spy에 주입한다.
    let spy = MusicPlayerServiceSpy(wrapping: realService)
    let viewModel = MusicPlayerViewModel(player: spy)
    
    viewModel.playTrack(id: "track_123")
    XCTAssertEqual(spy.playCallCount, 1, "RealPlayer.play()가 한 번은 호출되어야 합니다.")
    XCTAssertEqual(viewModel.lastAction, "played:track_123")
  }
  
  func testPlayThenPause_recordsCallOrder() {
    let realService = RealPlayer() // 실제 개발할 때 사용하는 RealPlayer를 spy에 주입한다.
    let spy = MusicPlayerServiceSpy(wrapping: realService)
    let vm = MusicPlayerViewModel(player: spy)
    
    vm.playTrack(id: "A")
    vm.pauseTrack()
    vm.playTrack(id: "B")
    
    XCTAssertEqual(spy.callOrder,
                   ["play", "pause", "play"],
                   "메서드 호출 순서가 기록되어야 합니다.")
    XCTAssertEqual(spy.playedTrackIDs, ["A", "B"])
    XCTAssertEqual(spy.playCallCount, 2)
    XCTAssertEqual(spy.pauseCallCount, 1)
  }
}
