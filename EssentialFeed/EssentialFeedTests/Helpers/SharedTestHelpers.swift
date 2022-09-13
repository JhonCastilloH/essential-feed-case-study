//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 13/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any Error", code: 0)
}

func anyUrl() -> URL {
    return URL(string: "http://any-url.com")!
}
