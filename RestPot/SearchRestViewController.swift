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

class SearchRestViewController: UIViewController {
    
    let toRestListIdentifier = "toRestList"
    
    var locationManager: CLLocationManager?
    
    var needToShowRestListView = false
    var successUpdatingLocation = false
    
    var range: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // NavigationBar
        AppIconWhiteImageView.setNavigationTitle(withNavigationItem: navigationItem)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // LocationManager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager?.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toRestListIdentifier {
            let restListVC = segue.destination as! RestListViewController
            restListVC.searchParams = sender as! GurunaviRequestParams
        }
    }
    
    func toRestListView() {
        if !successUpdatingLocation {
            locationManager?.requestLocation()
            showIndicator(with: "現在位置取得中")
            needToShowRestListView = true
            return
        }
        let params = GurunaviRequestParams()
        params.location(latitude: latitude, longitude: longitude)
        params.range(range)
        performSegue(withIdentifier: toRestListIdentifier, sender: params)
    }
    
    func searchRestaulant(withRange range: Int) {
        self.range = range
        if !CLLocationManager.locationServicesEnabled() {
            showAlert(withTitle: NSLocalizedString("位置情報を取得できません", comment: ""))
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            showAlert(withTitle: NSLocalizedString("位置情報取得を拒否されました", comment: ""))
            break
        case .authorizedAlways, .authorizedWhenInUse:
            toRestListView()
            break
        }
    }
    
    @IBAction func searchFor3km(_ sender: RangeRingButton) {
        searchRestaulant(withRange: 5)
    }
    
    @IBAction func searchFor2km(_ sender: RangeRingButton) {
        searchRestaulant(withRange: 4)
        
    }
    
    @IBAction func searchFor1km(_ sender: RangeRingButton) {
        searchRestaulant(withRange: 3)
        
    }
    
    @IBAction func searchFor500m(_ sender: RangeRingButton) {
        searchRestaulant(withRange: 2)
        
    }
    
    @IBAction func searchFor300m(_ sender: RangeRingButton) {
        searchRestaulant(withRange: 1)
        
    }
}

extension SearchRestViewController: CLLocationManagerDelegate {
    
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
        hideIndicator()
        guard let newLocation = locations.last else {
            return
        }
        successUpdatingLocation = true
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        print("location = [\(latitude), \(longitude)]")
        
        if needToShowRestListView {
            needToShowRestListView = false
            toRestListView()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        hideIndicator()
        successUpdatingLocation = false
        print(error)
        showAlert(withTitle: NSLocalizedString("位置情報の取得に失敗しました", comment: ""))
    }

}

