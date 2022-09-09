//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by john Castillo on 18/08/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    internal typealias Error = RemoteFeedLoader.Error
    
    static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse ) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.items
    }
}

