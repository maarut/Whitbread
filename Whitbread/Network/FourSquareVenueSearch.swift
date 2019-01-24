//
//  FourSquareVenueSearch.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - FourSquareVenueSearchResultsProcessor Protocol
protocol FourSquareVenueSearchResultsProcessor: class
{
    func process(venues: [Venue])
    func handle(error: NSError)
}

// MARK: - FourSquareVenueSearchError Enum
enum FourSquareVenueSearchError: Int
{
    case noData
    case jsonParse
}

// MARK: - FourSquareVenueSearchCriteria Struct
struct FourSquareVenueSearchCriteria: FourSquareNetworkOperationRequestor
{
    static let MaxRadius = 100000
    let centrePoint: CLLocationCoordinate2D
    let radius: Int
    
    var request: URLRequest {
        let parameters: [String: Any] = [
            "ll": "\(centrePoint.latitude),\(centrePoint.longitude)",
            "radius": radius,
            "section": "topPicks"
        ]
        return URLRequest(url: FourSquareURL(method: "venues/explore", parameters: parameters).url as URL)
    }
    
    init(centrePoint: CLLocationCoordinate2D, radius: Int)
    {
        self.centrePoint = centrePoint
        self.radius = radius < FourSquareVenueSearchCriteria.MaxRadius ?
            radius :
            FourSquareVenueSearchCriteria.MaxRadius
    }
    
    
}

// MARK: - FourSquareVenueSearch Class
class FourSquareVenueSearch: FourSquareNetworkOperationProcessor {
    private weak var resultsHandler: FourSquareVenueSearchResultsProcessor?

    init(resultsHandler: FourSquareVenueSearchResultsProcessor)
    {
        self.resultsHandler = resultsHandler
    }
    
    func process(data: Data)
    {
        let decoder = JSONDecoder()
        guard let parsedJson = try? decoder.decode(VenueResponseObject.self, from: data) else {
            let userInfo = [NSLocalizedDescriptionKey: "Returned data was not formatted as expected."]
            let error = NSError(domain: "FourSquareVenueSearch.processData",
                                code: FourSquareVenueSearchError.jsonParse.rawValue, userInfo: userInfo)
            handle(error: error)
            return
        }
        if let groups = parsedJson.response?.groups {
            let venues = groups.flatMap { group in
                group.items.map( { item in item.venue } )
            }
            resultsHandler?.process(venues: venues)
        }
        else {
            let userInfo = [NSLocalizedDescriptionKey: "No venues in response."]
            let error = NSError(domain: "FourSquareVenueSearch.processData",
                                code: FourSquareVenueSearchError.noData.rawValue, userInfo: userInfo)
            handle(error: error)
        }
        
    }
    
    func handle(error: NSError) {
        resultsHandler?.handle(error: error)
    }
}
