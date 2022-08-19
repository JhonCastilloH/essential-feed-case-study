//
//  HttpClient.swift
//  EssentialFeed
//
//  Created by john Castillo on 18/08/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
