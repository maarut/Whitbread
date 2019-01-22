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
    @IBOutlet var map: MKMapView!
    @IBOutlet var searchBar: UISearchBar!

    @IBAction func didTapOnMap(_ recogniser: UITapGestureRecognizer) {
        unfocusSearchBar()
    }
}

private extension ViewController {
    func unfocusSearchBar() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
}

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
            return pin
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // TODO: Perform search with text
    }
}
