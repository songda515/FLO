//
//  MusicPlayer.swift
//  FLO
//
//  Created by Dain Song on 2021/06/23.
//

import AVFoundation

class MusicPlayer {

    // MARK: - Singleton
    static let shared = MusicPlayer()
    
    // MARK: - Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    var url: String!
    
    var duration: TimeInterval {
        return self.player.duration
    }
    
    var currentValue: Float {
        return Float(self.player.currentTime)
    }
    
    var maximumValue: Float {
        return Float(self.player.duration)
    }
    
    var totalTime: String {
        return timeText(time: self.player.duration)
    }
    
    var currentTime: String {
        return timeText(time: self.player.currentTime)
    }
    
    func setCurrentTime(_ time: TimeInterval) {
        self.player.currentTime = time
    }
    
    func timeText(time: TimeInterval) -> String {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02ld:%02ld", minute, second)
    }

    func initPlayer(url urlString: String) {
        guard let url = URL(string: urlString) else {
            print("wrong url")
            return
        }
        do {
            let soundData = try Data(contentsOf: url)
            self.player = try AVAudioPlayer(data: soundData)
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드: \(error.code), 메세지 : \(error.localizedDescription)")
        }
    }
    
    func play(_ block: @escaping (Timer) -> Void) {
        self.player.play()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: block)
        self.timer.fire()
    }
    
    func pause() {
        self.player.pause()
        self.timer.invalidate()
        self.timer = nil
    }
}

