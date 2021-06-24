//
//  PlayerViewModel.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import Foundation

class PlayerViewModel {

    var apiManager: APIManger = APIManger()
    var music: Observable<Music> = Observable(Music.EMPTY)
    var imageData: Observable<Data> = Observable(Data())
    
    func fetchMusic() {
        self.apiManager.getMusic { (music) in
            print("fetch music ::", music.title)
            self.music = Observable(music)
            let imageURL = music.image
            self.apiManager.loadImageData(url: imageURL) { (image) in
                self.imageData = Observable(image)
            }
        }
    }
    
}
