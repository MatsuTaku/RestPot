//
//  RestListViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/08.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

extension Segue {
    static let toRestDetailIdentifier: String = "toRestDetail"
}

class RestListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.textColor = UIColor.white
        let fontSize = label.font.pointSize
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.sizeToFit()
        return label
    }()
    lazy private var numOfRestLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    
    var request: GurunaviRequest?
    
    var restList: [Restaulant] = []
    lazy var searchParams: GurunaviRequestParams = GurunaviRequestParams()
    var totalHitCount: Int?
    var showingListCount = 0
    var didUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 288
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        setTitleView()
        
        searchRestaulant(withHud: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        request?.cancel()
        hideHUD()
    }
    
    // MARK: - Set up NavigationBarTitleView
    
    func setTitleView() {
        setTitleView(withNumOfRest: nil)
    }
    
    func setTitleView(withNumOfRest num: Int?) {
        if totalHitCount == num { return }
        totalHitCount = num
        let titleStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        guard let navBarFrame = navigationController?.navigationBar.bounds else {
            return
        }
        titleStackView.center = CGPoint(x: navBarFrame.width/2, y: navBarFrame.height/2)
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
        if animated { showHUD() }
        request = GurunaviRequest()
        request?.post(searchParams, completionHandler: { response in
            if animated { self.hideHUD() }
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
            searchParams.offsetPage = page + 1
            searchRestaulant(withHud: false)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toRestDetailIdentifier {
            let restDetailVC = segue.destination as! RestDetailViewController
            restDetailVC.rest = sender as! Restaulant
        }
    }
    
}

extension RestListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        performSegue(withIdentifier: Segue.toRestDetailIdentifier, sender: restList[indexPath.row])
    }
    
}

extension RestListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y + tableView.bounds.height > tableView.contentSize.height {
            loadTableView()
        }
    }

}
