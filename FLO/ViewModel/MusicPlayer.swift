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
    var player = AVPlayer()
    var isPlaying: Bool = false
    
    var duration: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    var totalTimeText: String {
        return timeText(time: duration)
    }
    
    var currentTime: CMTime {
        return player.currentItem?.currentTime() ?? CMTime.zero
    }
    
    var currentValue: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    var currentTimeText: String {
        return timeText(time: currentValue)
    }
    
    func seek(_ time: CMTime) {
        player.seek(to: time)
    }
    
    func timeText(time: Double) -> String {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02ld:%02ld", minute, second)
    }

    func initPlayer(url urlString: String) {
        guard let url = URL(string: urlString) else {
            print("wrong url")
            return
        }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
    }
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping(CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}

