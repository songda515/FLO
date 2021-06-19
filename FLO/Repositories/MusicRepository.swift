//
//  MusicRepository.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import Foundation

class MusicRepository {
    
    private let httpClient = HttpClient<Int>()
    
    /// JSON Data 를 Music 모델로 파싱해서 반환하는 함수
    func getMusic(completed: @escaping (Music) -> Void) {
        
        let urlRequest = httpClient.getUrlRequest(httpClient.baseUrl)
        
        httpClient.getJsonData(of: urlRequest) { (result) in
            if let jsonData = try? result.get() {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Music.self, from: jsonData)
                    completed(response)
                } catch {
                    completed(Music.EMPTY)
                }
            }
        }
    }
}
