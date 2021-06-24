//
//  PlayerViewModel.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

class PlayerViewModel {

    var apiManager: APIManger
    var music: Observable<Music>
    var imageData: Data
    var player: MusicPlayer
    var lyricsDict: [Int:String]
    
    init() {
        self.apiManager = APIManger()
        self.music = Observable(Music.EMPTY)
        self.imageData = Data()
        self.player = MusicPlayer.shared
        self.lyricsDict = [Int:String]()
    }
    
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
        let lyrics = music.value.lyrics.split(separator: "\n").map{String($0)}
        for line in lyrics {
            let time = line.getArrayAfterRegex(regex: "[0-9]*:*").joined()
            let splitedTime = time.split(separator: ":").map{String($0)}
            let minute = Int(splitedTime[0])!
            let second = Int(splitedTime[1])!
            let timeKey = minute * 60 + second
            lyricsDict[timeKey] = String(line.split(separator: "]")[1])
        }
    }
}

extension PlayerViewModel {
    
    func configure(_ view: PlayerViewController) {
        initalizeUI(view)
        initializePlayer(view)
    }
    
    func initalizeUI(_ view: PlayerViewController) {
        view.albumLabel.text = music.value.album
        view.singerLabel.text = music.value.singer
        view.titleLabel.text = music.value.title
        view.thumbImage.image = UIImage(data: imageData)
    }
    
    func initializePlayer(_ view: PlayerViewController) {
        player.initPlayer(url: music.value.file)
        print(player.player)
        view.progressSlider.maximumValue = player.maximumValue
        view.progressSlider.minimumValue = 0
        view.progressSlider.value = player.currentValue
        view.totalTimeLabel.text = player.totalTime
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
