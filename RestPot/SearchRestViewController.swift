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
    
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangePickerView: UIPickerView!
    var isEditRange: Bool = false
    
    var locationManager: CLLocationManager?
    
    var latitude: Double = 0
    var longitude: Double = 0
    var range: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewSetUp()
        updateParameters()
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
        AppIconWhiteImageView.setNavigationTitle(withNavigationItem: navigationItem)
        let edit = UITapGestureRecognizer(target: self, action: #selector(SearchRestViewController.showRangePicker))
        rangeLabel.addGestureRecognizer(edit)
        let endEdit = UITapGestureRecognizer(target: self, action: #selector(SearchRestViewController.hideRangePicker))
        self.view.addGestureRecognizer(endEdit)
        rangePickerView.selectRow(range-1, inComponent: 0, animated: false)
        hideRangePicker()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func showRangePicker() {
        print("showRangePicker")
        toggleRangePicker(shouldEdit: true)
    }
    
    func hideRangePicker() {
        print("hideRangePicker")
        toggleRangePicker(shouldEdit: false)
    }
    
    func toggleRangePicker(shouldEdit: Bool) {
        if isEditRange == shouldEdit { return }
        isEditRange = shouldEdit
        rangePickerView.isHidden = false
        UIView.animate(withDuration: 0.5, animations:  {
            self.rangePickerView.alpha = shouldEdit ? 1 : 0
        }, completion: { _ in
            self.rangePickerView.isHidden = !shouldEdit
        })
    }
    
    func updateParameters() {
        rangeLabel.text = SearchParameters.ranges[range-1]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestList" {
            let restListVC = segue.destination as! RestListViewController
            restListVC.searchParams = sender as! [String: Any]
        }
    }
    
    @IBAction func toSearchRestaulantView() {
        let params: [String: Any] = [
            "keyid": GurunaviRequest.keyid,
            "format": "json",
            "latitude": latitude,
            "longitude": longitude,
            "range": range
        ]
        
        performSegue(withIdentifier: "toRestList", sender: params)
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
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        range = row + 1
        updateParameters()
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

