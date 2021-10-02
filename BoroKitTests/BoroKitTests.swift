//
//  BoroKitTests.swift
//  BoroKitTests
//
//  Created by Joss Manger on 10/2/21.
//

import XCTest
import CoreLocation

@testable import BoroKit

class BoroKitTests: XCTestCase {
  
  var coder: CLGeocoder?
  
  override func setUp() {
    coder = CLGeocoder()
  }
  
  override func tearDown() {
    coder = nil
  }
  
  func performLocationMatchCheck(location: CLLocation, matching: Boro){
    
    let expectation = XCTestExpectation(description: "wait for reverse geocode")
    var borough: Boro?
    
    coder?.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
      
      if let _ = error {
        XCTFail()
      }
      
      if let main = placemarks?.first {
        
        borough = Boro(placemark: main)
        expectation.fulfill()
      }
      
    })
    
    wait(for: [expectation], timeout: 2)
    
    XCTAssert(borough! == matching)
    
  }
  
  func testBrooklynExample() throws {
    let bkLat = CLLocationDegrees(40.68681)
    let bkLng = CLLocationDegrees(-73.98089)
    let brooklynLocation = CLLocation(latitude: bkLat, longitude: bkLng)
    performLocationMatchCheck(location: brooklynLocation, matching: .brooklyn)
  }
  
  func testManhattanExample() throws {
    //40.70383° N, 74.01615° W
    let bpLat = CLLocationDegrees(40.70383)
    let bpLng = CLLocationDegrees(-74.01615)
    let batteryPark = CLLocation(latitude: bpLat, longitude: bpLng)
    
    performLocationMatchCheck(location: batteryPark, matching: .manhattan)
    
  }
  
  func testQueensExample() throws {
    //40.74894° N, 73.90352° W
    let qulat = CLLocationDegrees(40.74894)
    let qlng = CLLocationDegrees(-73.90352)
    let qlocation = CLLocation(latitude: qulat, longitude: qlng)
    
    performLocationMatchCheck(location: qlocation, matching: .queens)
  }
  
  func testSIExample() throws {
    //40.64060° N, 74.08014° W
    let silat = CLLocationDegrees(40.64060)
    let silng = CLLocationDegrees(-74.08014)
    let silocation = CLLocation(latitude: silat, longitude: silng)
    
    performLocationMatchCheck(location: silocation, matching: .statenIsland)
  }
  
  func testBronxExample() throws {
    //40.83464° N, 73.90458° W
    let bxlat = CLLocationDegrees(40.83464)
    let bxlng = CLLocationDegrees(-73.90458)
    let bronxLocation = CLLocation(latitude: bxlat, longitude: bxlng)
    
    performLocationMatchCheck(location: bronxLocation, matching: .bronx)
    
  }
  
  func testNewarkExample() throws {
    //40.73474° N, 74.16590° W
    
    let njlat = CLLocationDegrees(40.73474)
    let njlng = CLLocationDegrees(-74.16590)
    let njLocation = CLLocation(latitude: njlat, longitude: njlng)
    performLocationMatchCheck(location: njLocation, matching: .six)
  }
  
  func testOutExample() throws {
    //51.54223° N, 0.93630° W
    
    let outlat = CLLocationDegrees(51.54223)
    let outlng = CLLocationDegrees(-0.93630)
    let outLocation = CLLocation(latitude: outlat, longitude: outlng)
    performLocationMatchCheck(location: outLocation, matching: .out)
  }
  
}
