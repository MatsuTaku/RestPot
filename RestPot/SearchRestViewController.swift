//
//  ViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class SearchRestViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var latitude: Double = 0
    var longitude: Double = 0
    var range: Int = 2

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        indicator.isHidden = true
        
        startUpdateLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startUpdateLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopUpdateLocating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchRestaulant() {
        let params: [String: Any] = [
            "keyid": GurunaviRequest.keyid,
            "format": "json",
            "latitude": latitude,
            "longitude": longitude,
            "range": range
        ]
        startIndicatorAnimating()
        GurunaviRequest().post(params, completionHandler: { response in
            self.stopIndicatorAnimating()
            
            print(response)
            if (response.result.error != nil) {
                print(response.result.error!)
            } else {
                guard let data = response.data else {
                    return
                }
                let jsonData = JSON(data)
                let restList = jsonData["rest"]
                
                self.performSegue(withIdentifier: "toRestList", sender: restList)
            }
        })
    }
    
    func startIndicatorAnimating() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func stopIndicatorAnimating() {
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
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
        //print("location = [\(latitude), \(longitude)]")
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }
    }
    
    func stopUpdateLocating() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.stopUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestList" {
            let restListVC = segue.destination as! RestListViewController
            restListVC.restList = (sender as! JSON).map{(_, rest) in Restaulant(rest)}
        }
    }


}

