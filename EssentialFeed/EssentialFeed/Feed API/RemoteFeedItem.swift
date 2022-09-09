//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by john Castillo on 8/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
