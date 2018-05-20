//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Marcus Gardner on 20/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import XCTest
@testable import RecipeApp

class RecipeAppTests: XCTestCase {
    
    func testHelloWorld(){
        var helloWorld: String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }
    
}
