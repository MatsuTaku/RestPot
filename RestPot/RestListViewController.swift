//
//  RestListViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class RestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var restList: [Restaulant] = []
    var searchParams: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchRestaulant()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchRestaulant() {
        startIndicatorAnimating()
        GurunaviRequest().post(searchParams, completionHandler: { response in
            self.stopIndicatorAnimating()
            
            if (response.result.error != nil) {
                print(response.result.error!)
            } else {
                guard let data = response.data else {
                    return
                }
                let jsonData = JSON(data)
                self.restList = jsonData["rest"].map{ (_, json) in Restaulant(json) }
                self.tableView.reloadData()
            }
        })
    }
    
    func startIndicatorAnimating() {
        SVProgressHUD.show()
    }
    
    func stopIndicatorAnimating() {
        SVProgressHUD.dismiss()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestDetail" {
            let restDetailVC = segue.destination as! RestDetailViewController
            restDetailVC.rest = sender as! Restaulant
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestListViewCell") as! RestListViewCell
        cell.setupCell(restList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toRestDetail", sender: restList[indexPath.row])
    }

}
