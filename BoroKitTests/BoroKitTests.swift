//
//  BoroKitTests.swift
//  BoroKitTests
//
//  Created by Joss Manger on 10/4/21.
//

import XCTest
@testable import BoroKit

class BoroKitTests: XCTestCase {

  let bm = BoroManager()

    func testSpamOfLocationLookups() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      var unfairExpectations = [XCTestExpectation]()
      for i in 0...1000 {
        let expectation = XCTestExpectation(description: "expectation for \(i)")
        bm.getCurrent { newboro in
          print("test for \(i) succeeded")
          expectation.fulfill()
        }
        unfairExpectations.append(expectation)
      }
      
      wait(for: unfairExpectations, timeout: 10)
      
    }

}
