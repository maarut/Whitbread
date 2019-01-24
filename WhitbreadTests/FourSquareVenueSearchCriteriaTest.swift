//
//  FourSquareVenueSearchCriteriaTest.swift
//  WhitbreadTests
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Whitbread

class StubFourSquareSearchProcessor: FourSquareVenueSearchResultsProcessor {
    private let processExpectation: XCTestExpectation?
    private let errorExpectation: XCTestExpectation?
    init(processExpectation: XCTestExpectation?, errorExpectation: XCTestExpectation?) {
        self.processExpectation = processExpectation
        self.errorExpectation = errorExpectation
    }
    func process(venues: [Venue]) {
        processExpectation?.fulfill()
    }
    
    func handle(error: NSError) {
        errorExpectation?.fulfill()
    }
}

class FourSquareVenueSearchCriteriaTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchCriteriaConstruction() {
        let lat: Double = 1
        let long: Double = 1
        let rad = 50
        let searchCriteria = FourSquareVenueSearchCriteria(centrePoint: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: rad)
        let request = searchCriteria.request
        XCTAssertEqual(request.url?.scheme, "https", "Sheme")
        XCTAssertEqual(request.url?.host, "api.foursquare.com", "Host")
        XCTAssertEqual(request.url?.path, "/v2/venues/explore", "Path")
        if let query = request.url?.query {
            XCTAssertTrue(query.contains("ll=\(lat),\(long)"))
            XCTAssertTrue(query.contains("radius=\(rad)"))
            XCTAssertTrue(query.contains("client_id="))
            XCTAssertTrue(query.contains("client_secret="))
            XCTAssertTrue(query.contains("v="))
        }
        else {
            XCTFail("Query")
        }
    }
    
    func testSearchRequest() {
        let lat: Double = 1
        let long: Double = 1
        let rad = 50
        let searchCriteria = FourSquareVenueSearchCriteria(centrePoint: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: rad)
        let asyncExpectation = XCTestExpectation(description: "venue processor")
        let processor = StubFourSquareSearchProcessor(processExpectation: asyncExpectation, errorExpectation: nil)
        FourSquareClient.instance.getVenues(searchCriteria, resultsProcessor: processor)
        
        wait(for: [asyncExpectation], timeout: 5)
    }
    
    func testBadDataInCriteria() {
        let lat: Double = 1000
        let long: Double = 1000
        let rad = 50000000
        let searchCriteria = FourSquareVenueSearchCriteria(centrePoint: CLLocationCoordinate2D(latitude: lat, longitude: long), radius: rad)
        let asyncExpectation = XCTestExpectation(description: "venue processor")
        let processor = StubFourSquareSearchProcessor(processExpectation: nil, errorExpectation: asyncExpectation)
        FourSquareClient.instance.getVenues(searchCriteria, resultsProcessor: processor)
        
        wait(for: [asyncExpectation], timeout: 5)
    }
}
