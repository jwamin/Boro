//
//  BoroKitTests.swift
//  BoroKitTests
//
//  Created by Joss Manger on 10/4/21.
//

import XCTest
@testable import BoroKit

class BoroKitTests: XCTestCase {
  
  func testSpamOfLocationLookups() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let bm = BoroManager()
    var unfairExpectations = [XCTestExpectation]()
    for i in 0...1000 {
      let expectation = XCTestExpectation(description: "expectation for \(i)")
      bm.getCurrent { newboro in
        print("test for \(i) succeeded")
        expectation.fulfill()
      }
      unfairExpectations.append(expectation)
    }
    
    wait(for: unfairExpectations, timeout: 2)
    
  }
  
  func testNoOverflowOfMarkedLookups() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    let bm = BoroManager()
    
    var expectations = [XCTestExpectation]()
    
    let bespokeUUID = UUID()
    
    for i in 1...1000 {
      
      let expectation = XCTestExpectation(description: "no overflow expectation for \(i)")
      if i < 1000 {
        expectation.isInverted = true
      }
      
      bm.getCurrent(origin: .other(id: bespokeUUID)){ newboro in
        print("test for \(i) succeeded")
        expectation.fulfill()
      }
      
      expectations.append(expectation)
      
      XCTAssert(bm.callbackSet.count <= 1, "bm failure \(bm.callbackSet)")
      
    }
    
    wait(for: expectations, timeout: 2)
    
    XCTAssert(bm.callbackSet.isEmpty, "callback set is not empty \(bm.callbackSet)")
    
  }
  
}
