//
//  Graph.CacheTests.swift
//  BuyTests
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import Buy

class Graph_CacheTests: XCTestCase {
    
    enum Query {
        case one  
        case two  
        case three
        
        var data: Data {
            switch self {
            case .one:   return "query { shop { name } }".data(using: .utf8)!
            case .two:   return "query { shop { id } }".data(using: .utf8)!
            case .three: return "query { shop { id name } }".data(using: .utf8)!
            }
        }
    }

    // ----------------------------------
    //  MARK: - Init -
    //
    func testInit() {
        let cache = Graph.Cache()
        XCTAssertNotNil(cache)
    }
    
    // ----------------------------------
    //  MARK: - Purge -
    //
    func testPurge() {
        let cache   = self.defaultCache()
        let request = self.defaultRequest(query: .two)
        
        cache.purge()
        
        let data = cache.data(for: request.hash)
        XCTAssertEqual(data, nil)
        
        cache.set(request.httpBody!, for: request.hash)
        
        let data2 = cache.data(for: request.hash)
        XCTAssertEqual(data2, request.httpBody)
        
        cache.purge()
        
        let data3 = cache.data(for: request.hash)
        XCTAssertEqual(data3, nil)
    }
    
    // ----------------------------------
    //  MARK: - Accessors -
    //
    func testRetrieveEmpty() {
        let cache   = self.defaultCache()
        let request = self.defaultRequest()
        
        cache.purge()
        
        let data = cache.data(for: request.hash)
        XCTAssertNil(data)
    }
    
    func testStoreAndRetrieve() {
        let cache   = self.defaultCache()
        let request = self.defaultRequest()
        
        cache.purge()
        cache.set(request.httpBody!, for: request.hash)
        
        let data = cache.data(for: request.hash)
        XCTAssertEqual(request.httpBody!, data)
    }
    
    // ----------------------------------
    //  MARK: - Private -
    //
    private func defaultCache() -> Graph.Cache {
        return Graph.Cache()
    }
    
    private func defaultRequest(query: Query = .one) -> URLRequest {
        var request      = URLRequest(url: URL(string: "https://www.google.com")!)
        request.httpBody = query.data
        return request
    }
}
