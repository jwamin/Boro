//
//  BoroKitTests.swift
//  BoroKitTests
//
//  Created by Joss Manger on 10/2/21.
//

import XCTest
import CoreLocation

@testable import BoroKit

class BoroTests: XCTestCase {
    
    var coder: CLGeocoder?
    
    override func setUp() {
        coder = CLGeocoder()
    }
    
    override func tearDown() {
        coder = nil
    }
    
    func performLocationMatchCheck(location: CLLocation, matching: Boro){
        
        let expectation = XCTestExpectation(description: "wait for reverse geocode")
        var borough: Boro = .out
        
        coder?.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            
            if let err = error {
                XCTFail("there was an error raised by reverse geocode \(err)")
            }
            
            if let main = placemarks?.first {
                
                borough = Boro(placemark: main)!
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(borough == matching)
        
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
        performLocationMatchCheck(location: njLocation, matching: .out)
    }
    
    func testJCExample() throws {
        //40.71512° N, 74.03598° W
        let njlat = CLLocationDegrees(40.71512)
        let njlng = CLLocationDegrees(-74.03598)
        let njLocation = CLLocation(latitude: njlat, longitude: njlng)
        performLocationMatchCheck(location: njLocation, matching: .six)
    }
    
    func testHoboExample() throws {
        //40.74051° N, 74.03286° W
        let njlat = CLLocationDegrees(40.74051)
        let njlng = CLLocationDegrees(-74.03286)
        let njLocation = CLLocation(latitude: njlat, longitude: njlng)
        performLocationMatchCheck(location: njLocation, matching: .six)
    }
    
    func testUCExample() throws {
        //40.77608° N, 74.01975° W
        let njlat = CLLocationDegrees(40.77608)
        let njlng = CLLocationDegrees(-74.01975)
        let njLocation = CLLocation(latitude: njlat, longitude: njlng)
        performLocationMatchCheck(location: njLocation, matching: .six)
    }
    
    func testUpstateExample() throws {
        //41.72332° N, 74.30040° W // upstate, catskills
        
        let upstateLat = CLLocationDegrees(41.72332)
        let upstateLng = CLLocationDegrees(-74.30040)
        let upstateLocation = CLLocation(latitude: upstateLat, longitude: upstateLng)
        performLocationMatchCheck(location: upstateLocation, matching: .out)
    }
    
    func testOutExample() throws {
        //51.54223° N, 0.93630° W
        
        let outlat = CLLocationDegrees(51.54223)
        let outlng = CLLocationDegrees(-0.93630)
        let outLocation = CLLocation(latitude: outlat, longitude: outlng)
        performLocationMatchCheck(location: outLocation, matching: .out)
    }
    
}
