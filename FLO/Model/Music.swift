//
//  PlayerModel.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import Foundation

struct Music: Codable {
    
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
    
}

extension Music {
    static let EMPTY = Music(singer: "", album: "", title: "", duration: 0, image: "", file: "", lyrics: "")
}
