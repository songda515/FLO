//
//  HttpClient.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

struct APIManger {
    
    enum APIError: Error {
        case basic(Error)
        case response
        case status(Int)
        case emptyData
        
        var message: String {
            switch self {
            case .basic(let error):
                return error.localizedDescription
            case .response:
                return "response Error"
            case .status(let code):
                return "\(code) status Error"
            case .emptyData:
                return "empty Data"
            }
        }
    }
    
    let baseUrl = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    
    /// URLRequest 인스턴스를 받아 Request 를 요청하고 Response 를 받아 completion block 으로 전달하는 함수
    func request(of urlString: String, completed: @escaping (Result<Data, APIError>) -> Void) {
        
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                return completed(.failure(.basic(error!)))
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return completed(.failure(.response))
            }
            
            let successRange = 200..<300
            guard successRange.contains(statusCode) else {
                return completed(.failure(.status(statusCode)))
            }
            
            guard let data = data else {
                return completed(.failure(.emptyData))
            }
            
            completed(.success(data))
            
        }.resume()
    }
    
    /// JSON Data 를 Music 모델로 파싱해서 반환하는 함수
    func getMusic(completed: @escaping (Music) -> Void) {
        
        self.request(of: self.baseUrl) { (result) in
            switch result {
            case .success(let jsonData):
                do {
                    let decoder = JSONDecoder()
                    let music = try decoder.decode(Music.self, from: jsonData)
                    completed(music)
                } catch {
                    completed(Music.EMPTY)
                }
            case .failure(let error):
                print(error.message)
                completed(Music.EMPTY)
            }
        }
    }
    
    /// image URL 을 전달받아 Data 타입으로 반환하는 함수
    func loadImageData(url: String, completed: @escaping (Data) -> Void) {
        
        self.request(of: url) { (result) in
            switch result {
            case .success(let data):
                completed(data)
            case .failure(let error):
                print(error.message)
                completed(Data())
            }
        }
    }
}
