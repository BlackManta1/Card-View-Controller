//
//  ExtensionMap.swift
//  Slide Out
//
//  Created by Saliou DJALO on 12/08/2019.
//  Copyright © 2019 Saliou DJALO. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ViewController : CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 3 updates max
        if updateCount < 3 {
            if let center = locationManager.location?.coordinate {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 3000)
                mapView.setRegion(region, animated: true)
            }
            updateCount = updateCount + 1
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUpLocation()
        }
    }
    
    func processCLLocationManager() {
        locationManager.delegate = self
        // maniere correcte de faire
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUpLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    fileprivate func setUpLocation() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
}
