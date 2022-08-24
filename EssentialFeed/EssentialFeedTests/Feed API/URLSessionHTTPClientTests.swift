//
//  UrlSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 24/08/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest
import Foundation
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) {_,_,_ in }
    }
    
    
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url:URL  = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    // Mark
    
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
     
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return URLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }

}


