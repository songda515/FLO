//
//  HttpClient.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

struct APIManger<T: Codable> {
    
    private let baseUrl = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    
    /// 문자열의 URL 을 인자로 받아 URLRequest 인스턴스로 반환하는 함수
    private func getUrlRequest(_ urlString: String) -> URLRequest? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    /// URLRequest 인스턴스를 받아 Request 를 요청하고 Response 를 받아 completion block 으로 전달하는 함수
    private func request(of urlRequest: URLRequest, completed: @escaping (Result<Data, Error>) -> Void) {

        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in

            guard error == nil else {
                completed(Result.failure(error!))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            let successRange = 200..<300
            guard successRange.contains(statusCode) else {
                return
            }
            guard let data = data else {
                return
            }
            completed(Result.success(data))
        }
        dataTask.resume()
    }
    
    /// JSON Data 를 Music 모델로 파싱해서 반환하는 함수
    func getMusic(completed: @escaping (Music) -> Void) {
        
        guard let urlRequest = self.getUrlRequest(self.baseUrl) else {
            completed(Music.EMPTY)
            return
        }
        
        self.request(of: urlRequest) { (result) in
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
    
    /// image URL 을 전달받아 Data 타입으로 반환하는 함수
    func loadImageData(url: String, completed: @escaping (Data) -> Void) {
        
        guard let urlRequest = self.getUrlRequest(url) else {
            completed(Data())
            return
        }
        
        self.request(of: urlRequest) { (result) in
            if let data = try? result.get() {
                completed(data)
            } else {
                completed(Data())
            }
        }
    }
}
