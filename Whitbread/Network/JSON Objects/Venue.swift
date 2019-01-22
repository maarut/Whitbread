//
//  Venue.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let formattedAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case formattedAddress
    }
}

struct Category: Codable {
    let name: String
}

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
    let categories: [Category]
}

struct VenueResponse: Codable {
    let venues: [Venue]
}

struct VenueResponseObject: Codable {
    // TODO: - Deal with the meta object that contains error codes, and other metadata about the response.
    let response: VenueResponse?
}
