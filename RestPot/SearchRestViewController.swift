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

class SearchRestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var smallestRingRange: NSLayoutConstraint!
    @IBOutlet weak var secondRingDiff: NSLayoutConstraint!
    @IBOutlet weak var thirdRingDiff: NSLayoutConstraint!
    @IBOutlet weak var forthRingDiff: NSLayoutConstraint!
    @IBOutlet weak var fifthRingDiff: NSLayoutConstraint!
    @IBOutlet weak var ringsCenterY: NSLayoutConstraint!
    var ringsCenterPosition = CGPoint.zero
    
    let toRestListIdentifier = "toRestList"
    
    var isEditRange: Bool = false
    
    var locationManager: CLLocationManager?
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewSetUp()
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
    
    func viewSetUp() {
        // NavigationBar
        AppIconWhiteImageView.setNavigationTitle(withNavigationItem: navigationItem)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // RangeRingButtons
        let screenBounds = UIScreen.main.bounds
        ringsCenterPosition = CGPoint(x: screenBounds.width/2, y: screenBounds.height/2 + ringsCenterY.constant)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toRestListIdentifier {
            let restListVC = segue.destination as! RestListViewController
            restListVC.searchParams = sender as! GurunaviRequestParams
        }
    }
    
    func toSearchRestaulantView(withRange range: Int) {
        let params = GurunaviRequestParams()
        params.location(latitude: latitude, longitude: longitude)
        params.range(range)
        
        performSegue(withIdentifier: toRestListIdentifier, sender: params)
    }
    
    @IBAction func searchFor3km(_ sender: RangeRingButton) {
        toSearchRestaulantView(withRange: 5)
    }
    
    @IBAction func searchFor2km(_ sender: RangeRingButton) {
        toSearchRestaulantView(withRange: 4)
        
    }
    
    @IBAction func searchFor1km(_ sender: RangeRingButton) {
        toSearchRestaulantView(withRange: 3)
        
    }
    
    @IBAction func searchFor500m(_ sender: RangeRingButton) {
        toSearchRestaulantView(withRange: 2)
        
    }
    
    @IBAction func searchFor300m(_ sender: RangeRingButton) {
        toSearchRestaulantView(withRange: 1)
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SearchParameters.ranges.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SearchParameters.ranges[row]
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
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

}

