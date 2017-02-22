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
import Alamofire

class RestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    lazy private var titleLabel: UILabel = self.createTitleLabel()
    lazy private var numOfRestLabel: UILabel = self.createNumOfRestLabel()
    
    let toRestDetailIdentifier = "toRestDetail"
    
    var request: GurunaviRequest?
    
    var restList: [Restaulant] = []
    lazy var searchParams: GurunaviRequestParams = GurunaviRequestParams()
    var totalHitCount: Int?
    var showingListCount = 0
    var didUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.estimatedRowHeight = 288
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: .zero)
        setTitleView()
        
        searchRestaulant(withHud: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        request?.cancel()
        stopIndicatorAnimating()
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
        if totalHitCount == num { return }
        totalHitCount = num
        let titleStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        guard let navigationBarFrame = navigationController?.navigationBar.bounds else {
            return
        }
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
    
    func loadTableView() {
        if restList.count <= showingListCount { return }
        tableView.reloadData()
        showingListCount = restList.count
    }
    
    func searchRestaulant(withHud animated: Bool) {
        if animated { startIndicatorAnimating() }
        request = GurunaviRequest()
        request?.post(searchParams, completionHandler: { response in
            if animated { self.stopIndicatorAnimating() }
            response.rests?.forEach { self.restList.append($0) }
            if !self.didUpdated {
                self.didUpdated = true
                self.loadTableView()
            }
            self.setTitleView(withNumOfRest: response.totalHitCount)
            if let pageOffset = response.pageOffset,
            let totalHitCount = response.totalHitCount,
            let hitPerPage = response.hitPerPage {
                self.requestNextRestData(withRecieved: pageOffset,
                                     total: totalHitCount,
                                     hitPerPage: hitPerPage)
            }
        })
    }
    
    func requestNextRestData(withRecieved page: Int, total: Int, hitPerPage: Int) {
        let recievedRestCount = page * hitPerPage
        if recievedRestCount < total {
            searchParams.offsetPage(page + 1)
            searchRestaulant(withHud: false)
        }
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
        if segue.identifier == toRestDetailIdentifier {
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
        performSegue(withIdentifier: toRestDetailIdentifier, sender: restList[indexPath.row])
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y + tableView.bounds.height > tableView.contentSize.height {
            loadTableView()
        }
    }

}
