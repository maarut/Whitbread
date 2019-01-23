//
//  LocationSearch.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 23/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationSearchCompletedProtocol: class {
    func locationRetrieved(_ location: CLLocationCoordinate2D)
    func searchFailed(_ error: CLError)
}

class LocationSearch {
    
    weak var delegate: LocationSearchCompletedProtocol?
    private let geocoder = CLGeocoder()
    
    init() { }

    func reverseGeocode(placeName: String) {
        geocoder.geocodeAddressString(placeName) { [weak self] (placeMarks, error) in
            guard error == nil else {
                if let error = error as? CLError {
                    self?.delegate?.searchFailed(error)
                }
                return
            }
            if let placeMark = placeMarks?.first, let location = placeMark.location {
                self?.delegate?.locationRetrieved(location.coordinate)
            }
        }
    }
    
    func cancelSearch() {
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }
    }
}
