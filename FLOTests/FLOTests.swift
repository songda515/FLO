//
//  FLOTests.swift
//  FLOTests
//
//  Created by Dain Song on 2021/06/22.
//

import XCTest
@testable import FLO

class FLOTests: XCTestCase {
    
    var apiManager: APIManger!
    var playerViewModel: PlayerViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        apiManager = APIManger()
        playerViewModel = PlayerViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiManager = nil
        playerViewModel = nil
        try super.tearDownWithError()
    }

    func testRequestSuccess() throws {
        // 1. given
        let url = apiManager.baseUrl
        let promise = expectation(description: "Status code: 200")
        
        // 2. when
        apiManager.request(of: url) { (result) in
            // 3. then
            switch result {
            case .success(let jsonData):
                do {
                    let decoder = JSONDecoder()
                    let music = try decoder.decode(Music.self, from: jsonData)
                    XCTAssertNotNil(music)
                    promise.fulfill()
                } catch {
                    XCTFail("fail parsing Json")
                }
            case .failure(let error):
                XCTFail(error.message)
            }
        }
        // 3. then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestFail() throws {
        // 1. given
        let wrongUrl = "https://grepp-programmers-challenge.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        let promise = expectation(description: "Status code: 200")
        
        // 2. when
        apiManager.request(of: wrongUrl) { (result) in
            // 3. then
            switch result {
            case .success(let jsonData):
                do {
                    let decoder = JSONDecoder()
                    let music = try decoder.decode(Music.self, from: jsonData)
                    XCTAssertNotNil(music)
                    promise.fulfill()
                } catch {
                    XCTFail("fail parsing Json")
                }
            case .failure(let error):
                print(error.message)
                XCTFail(error.message)
            }
        }

        // 3. then
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetMusic() {
        apiManager.getMusic { (music) in
            XCTAssertNotEqual(music.title, "")
            XCTAssertNotEqual(music.singer, "")
            XCTAssertNotEqual(music.image, "")
            XCTAssertNotEqual(music.album, "")
            XCTAssertNotEqual(music.file, "")
            XCTAssertNotEqual(music.lyrics, "")
        }
    }
}
