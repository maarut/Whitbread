//
//  ViewControllerTests.swift
//  WhitbreadTests
//
//  Created by Maarut Chandegra on 23/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import XCTest
import MapKit
@testable import Whitbread

class ViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapPlotsNewVenues() {
        let vc = ViewController()
        vc.map = MKMapView(frame: .zero)
        
        let venues = [
            Venue(id: "1", name: "One", location:
                Location(latitude: 1, longitude: 1, formattedAddress: []), categories: []),
            Venue(id: "2", name: "Two", location:
                Location(latitude: 2, longitude: 2, formattedAddress: []), categories: []),
            Venue(id: "3", name: "Three", location:
                Location(latitude: 2, longitude: 2, formattedAddress: []), categories: []),
            ]
        XCTAssertEqual(vc.map.annotations.count, 0)
        vc.process(venues: venues)
        let expectation = XCTestExpectation(description: "venue process")
        DispatchQueue.main.async {
            if vc.map.annotations.count == venues.count {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testMapAnnotationsClearedOnReceiptOfVenues() {
        let vc = ViewController()
        vc.map = MKMapView(frame: .zero)
        let annotation = MKPointAnnotation()
        vc.map.addAnnotations([annotation])
        
        XCTAssertEqual(vc.map.annotations.count, 1)
        
        vc.process(venues: [])
        
        let expectation = XCTestExpectation(description: "venue clear")
        DispatchQueue.main.async {
            if vc.map.annotations.count == 0 {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrievingLocationCentersMap() {
        let vc = ViewController()
        vc.map = MKMapView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 480)))
        let center = CLLocationCoordinate2D(latitude: 45, longitude: 50)
        vc.locationRetrieved(center)
        let mapLat = XCTestExpectation(description: "map lat")
        let mapLong = XCTestExpectation(description: "map long")
        DispatchQueue.main.async {
            if abs(vc.map.centerCoordinate.longitude - center.longitude) < 0.1 {
                mapLong.fulfill()
            }
            if abs(vc.map.centerCoordinate.latitude - center.latitude) < 0.1 {
                mapLat.fulfill()
            }
        }
        wait(for: [mapLat, mapLong], timeout: 5)
    }
}
