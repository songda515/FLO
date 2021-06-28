//
//  PlayerViewModel.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

class PlayerViewModel {
    
    // MARK: - Singleton
    static let shared = PlayerViewModel()

    // MARK: - Properties
    var apiManager: APIManger
    var music: Observable<Music>
    var imageData: Data
    var player: MusicPlayer
    var lyricsDict: [Int:String]
    var lyricsArray: [String]
    var prevIndex: Int
    
    // MARK: Computed properties
    var album: String {
        return music.value.album
    }
    
    var title: String {
        return music.value.title
    }
    
    var singer: String {
        return music.value.singer
    }
    
    var musicFileUrl: String {
        return music.value.file
    }
    
    var lyrics: String {
        return music.value.lyrics
    }
    
    var lyricsCount: Int {
        return lyricsDict.count
    }
    
    var duration: Int {
        return music.value.duration
    }
    
    // MARK: - Initialize
    init() {
        self.apiManager = APIManger()
        self.music = Observable(Music.EMPTY)
        self.imageData = Data()
        self.player = MusicPlayer.shared
        self.lyricsDict = [Int:String]()
        self.lyricsArray = [String]()
        self.prevIndex = -1
    }
    
    // MARK: - Methods
    func fetchMusic() {
        apiManager.getMusic { (music) in
            print("fetch music ::", music.title)
            self.music = Observable(music)
            let imageURL = music.image
            self.apiManager.loadImageData(url: imageURL) { (image) in
                self.imageData = image
            }
            self.getLyrics()
        }
    }
    
    func getLyrics() {
        let lyrics = self.lyrics.split(separator: "\n").map{String($0)}
        lyricsDict[0] = "간주중"
        for line in lyrics {
            let time = line.getArrayAfterRegex(regex: "[0-9]*:*").joined()
            let splitedTime = time.split(separator: ":").map{String($0)}
            let minute = Int(splitedTime[0])!
            let second = Int(splitedTime[1])!
            let timeKey = minute * 60 + second
            let value = String(line.split(separator: "]")[1])
            lyricsDict[timeKey] = value
        }
        lyricsDict[duration] = "간주중"
        lyricsArray = lyricsDict.sorted { $0.key < $1.key }.map { $0.value }
    }
    
    func getCurrentLyrics(completed: @escaping (String) -> Void) {
        let currentTime = Int(player.currentValue)
        let times = lyricsDict.keys.sorted()
        let index = bisectRight(times, currentTime) - 1
        completed(lyricsDict[times[index]] ?? "")
    }
    
    func getCurrentLyricsIndex() -> Int {
        let currentTime = Int(player.currentValue)
        let times = lyricsDict.keys.sorted()
        let index = bisectRight(times, currentTime) - 1
        return index
    }
    
    func bisectRight(_ array: [Int], _ target: Int) -> Int {
        var start = 0
        var end = array.count - 1
        while start < end {
            let mid = (start + end) / 2
            if target < array[mid] {
                end = mid
            } else {
                start = mid + 1
            }
        }
        return start
    }
}

extension String{
    
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
