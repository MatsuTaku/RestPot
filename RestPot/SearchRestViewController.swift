//
//  ViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import CoreLocation

class SearchRestViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var latitude: Double = 0
    var longitude: Double = 0
    var range: Int = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startUpdateLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchRestaulant() {
        let request = GurunaviRequest()
        let params: [String: Any] = [
            "keyid=": GurunaviRequest.keyid,
            "latitude": "\(latitude)" as String,
            "longtitude": "\(longitude)" as String,
            "range=": String(range)
        ]
        request.get(params, completionHandler: {data, response, error in
            if (error == nil) {
                print(error)
            } else {
                
            }
        })
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }
    }
    
    func stipUpdateLocating() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.stopUpdatingLocation()
        }
    }


}

