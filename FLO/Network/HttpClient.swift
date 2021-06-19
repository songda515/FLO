//
//  HttpClient.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import Foundation

class HttpClient<T: Codable> {
    
    let baseUrl = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    
    /// 문자열의 URL 을 인자로 받아 URLRequest 인스턴스로 반환하는 함수
    func getUrlRequest(_ urlString: String) -> URLRequest {
        
        return URLRequest(url: URL(string: urlString)!)
    }
    
    /// URLRequest 인스턴스를 받아 Request 를 요청하고 Response 를 받아 completion block 으로 전달하는 함수
    func getJsonData(of urlRequest: URLRequest, completed: @escaping (Result<Data, Error>) -> Void) {

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
}
