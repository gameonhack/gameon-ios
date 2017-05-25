//
//  iOS_Tests.swift
//  iOS Tests
//
//  Created by Eduardo Irias on 3/5/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import XCTest
@testable import Game_On

class iOS_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPosts() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Got Posts")
        DataManager.getPosts { (posts, error) in
            XCTAssertNil(error)
            XCTAssertGreaterThan(posts?.count ?? 0, 0)
            userOpExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testGetEvents() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Got Events")
        DataManager.getEvents { (events, error) in
            XCTAssertNil(error)
            XCTAssertGreaterThan(events?.count ?? 0, 0)
            userOpExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testGetGroups() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Got Groups")
        DataManager.getGroups { (groups, error) in
            XCTAssertNil(error)
            XCTAssertGreaterThan(groups?.count ?? 0, 0)
            userOpExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
