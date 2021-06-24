//
//  PlayerViewModel.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

class PlayerViewModel {

    var apiManager: APIManger = APIManger()
    var music: Observable<Music> = Observable(Music.EMPTY)
    var imageData: Observable<Data> = Observable(Data())
    var player = MusicPlayer.shared
    
    func fetchMusic() {
        apiManager.getMusic { (music) in
            print("fetch music ::", music.title)
            self.music = Observable(music)
            let imageURL = music.image
            self.apiManager.loadImageData(url: imageURL) { (image) in
                self.imageData = Observable(image)
            }
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
        view.thumbImage.image = UIImage(data: imageData.value)
    }
    
    func initializePlayer(_ view: PlayerViewController) {
        player.initPlayer(url: music.value.file)
        //self.player.delegate = self
        //self.player.prepareToPlay()
        view.progressSlider.maximumValue = player.maximumValue
        view.progressSlider.minimumValue = 0
        view.progressSlider.value = player.currentValue
        view.totalTimeLabel.text = player.totalTime
    }
}
