//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 10/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrive
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retriveCompletions = [RetriveCompletion]()
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error:Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccesfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed:[LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error:Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrive(completion: @escaping RetriveCompletion) {
        receivedMessages.append(.retrive)
        retriveCompletions.append(completion)
    }
    
    func completeRetrieval(with error:Error, at index: Int = 0) {
        retriveCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmpty(at index: Int = 0) {
        retriveCompletions[index](.empty)
    }
    
    func completeRetrieval(with feed:[LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retriveCompletions[index](.found(feed: feed, timestamp: timestamp))
    }
    
}

 
