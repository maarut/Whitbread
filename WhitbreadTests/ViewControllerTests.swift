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
        vc.process(venues: venues)
        
        
        XCTAssertEqual(vc.map.annotations.count, venues.count)
    }
    
    func testMapAnnotationsClearedOnReceiptOfVenues() {
        let vc = ViewController()
        vc.map = MKMapView(frame: .zero)
        let annotation = MKPointAnnotation()
        vc.map.addAnnotations([annotation])

        vc.process(venues: [])
        
        XCTAssertEqual(vc.map.annotations.count, 0)
    }
    
    func testRetrievingLocationCentersMap() {
        let vc = ViewController()
        vc.map = MKMapView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 480)))
        let center = CLLocationCoordinate2D(latitude: 45, longitude: 50)
        vc.locationRetrieved(center)
        
        XCTAssertEqual(vc.map.centerCoordinate.longitude, center.longitude, accuracy: 0.1)
        XCTAssertEqual(vc.map.centerCoordinate.latitude, center.latitude, accuracy: 0.1)
    }
}
