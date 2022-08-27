//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 27/08/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeak (_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should been deallocated, Potential memory leak.", file: file, line: line)
        }
    }
}
