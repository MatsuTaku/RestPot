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
    lazy private var titleLabel: UILabel = self.createTitleLabel()
    lazy private var numOfRestLabel: UILabel = self.createNumOfRestLabel()
    
    var restList: [Restaulant] = []
    var searchParams: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.estimatedRowHeight = 288
        self.tableView.rowHeight = UITableViewAutomaticDimension
        setTitleView()
        
        searchRestaulant()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Set up NavigationBarTitleView
    
    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = self.title
        label.textColor = UIColor.white
        let fontSize = label.font.pointSize
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.sizeToFit()
        return label
    }
    
    func createNumOfRestLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }
    
    func setTitleView() {
        setTitleView(withNumOfRest: nil)
    }
    
    func setTitleView(withNumOfRest num: Int?) {
        let titleStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let navigationBarFrame = navigationController!.navigationBar.bounds
        titleStackView.center = CGPoint(x: navigationBarFrame.width/2, y: navigationBarFrame.height/2)
        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        titleStackView.addArrangedSubview(titleLabel)
        numOfRestLabel.text = num != nil ? "\(num!)件" : " "
        numOfRestLabel.sizeToFit()
        titleStackView.addArrangedSubview(numOfRestLabel)
        self.navigationItem.titleView = titleStackView
    }
    
    // MARK: - Load Restaulant list methods
    
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
                self.setTitleView(withNumOfRest: self.restList.count)
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
    
    // MARK: - UITableViewDataSource
    
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
