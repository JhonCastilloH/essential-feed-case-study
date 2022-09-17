//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 17/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class CodableFeedStore  {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            self.id = image.id
            self.description = image.description
            self.location = image.location
            self.url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrive(completion: @escaping FeedStore.RetriveCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed:[LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp))
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let storeURL = storeURL()
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let storeURL = storeURL()
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrive{ result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrive_hasNoSideEffectsONEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrive{ firstResult in
            sut.retrive{ secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected receiving twicw empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retriveAfterinsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted sucessfully")
            
            sut.retrive{ retrieveResult in
                switch retrieveResult {
                case let .found(retrieveFeed, retrieveTimestamp):
                    XCTAssertEqual(retrieveFeed, feed)
                    XCTAssertEqual(retrieveTimestamp, timestamp)
                default:
                    XCTFail("Expected found result with feed \(feed) and timestap \(timestamp), got \(retrieveResult) instead")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // - MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL())
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func storeURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    }
}
