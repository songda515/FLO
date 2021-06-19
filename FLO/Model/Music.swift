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
    let image: String
    let file: String // mp3 파일 링크
    let lyrics: String // 시간으로 구분 된 가사
    
}

extension Music {
    static let EMPTY = Music(singer: "", album: "", title: "", image: "", file: "", lyrics: "")
}
