//
//  ViewController.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    private let venueReuseId = "venue"
    private let locationSearch = LocationSearch()
    @IBOutlet var map: MKMapView!
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        locationSearch.delegate = self
    }
    
    @IBAction func didTapOnMap(_ recogniser: UITapGestureRecognizer) {
        unfocusSearchBar()
    }
}

// MARK: - Private Functions
private extension ViewController {
    func unfocusSearchBar() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: - LocationSearchCompletedProtocol Implementation
extension ViewController: LocationSearchCompletedProtocol {
    func locationRetrieved(_ location: CLLocationCoordinate2D) {
        let criteria = FourSquareVenueSearchCriteria(centrePoint: location, radius: 1000)
        FourSquareClient.instance.getVenues(criteria, resultsProcessor: self)
        DispatchQueue.main.async { [weak self] in
            self?.map.setRegion(MKCoordinateRegionMakeWithDistance(location, 2000, 2000), animated: true)
        }
    }
    
    func searchFailed(_ error: CLError) {
        
    }
}

// MARK: - MKMapViewDelegate Implementation
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        unfocusSearchBar()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: venueReuseId) as? MKPinAnnotationView {
            pin.annotation = annotation
            return pin
        }
        else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: venueReuseId)
            pin.pinTintColor = MKPinAnnotationView.redPinColor()
            pin.canShowCallout = true
            return pin
        }
    }
}

// MARK: - UISearchBarDelegate Implementation
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            locationSearch.reverseGeocode(placeName: text)
        }
    }
}

// MARK: - FourSquareVenueSearchResultsProcessor Implementation
extension ViewController: FourSquareVenueSearchResultsProcessor {
    func process(venues: [Venue]) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.map.removeAnnotations(strongSelf.map.annotations)
                let annotations = venues.map { venue -> MKPointAnnotation in
                    let a = MKPointAnnotation.init()
                    a.coordinate = CLLocationCoordinate2D(latitude: venue.location.latitude,
                                                          longitude: venue.location.longitude)
                    a.title = venue.name
                    return a
                }
                strongSelf.map.addAnnotations(annotations)
            }
        }
    }
    
    func handle(error: NSError) {
        
    }
}
