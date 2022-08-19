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
        let items: [Item]
    }
    
    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return  try JSONDecoder().decode(Root.self, from: data).items.map{$0.item}
    }
    
}
