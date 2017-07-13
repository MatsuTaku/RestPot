//
//  RestDetailViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/09.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit

class RestDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rest: Restaulant!
    lazy var detailList: [RestDetail] = self.makeDetailList()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        AppIconWhiteImageView.setNavigationTitle(withNavigationItem: navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeDetailList() -> [RestDetail] {
        let list: [RestDetail?] = [
            RestDetail(title: .access, detail: rest.accessText()),
            RestDetail(title: .callNumber, detail: rest.tel),
            RestDetail(title: .budget, detail: rest.budget),
            RestDetail(title: .lunch, detail: rest.lunch),
            RestDetail(title: .party, detail: rest.party),
            RestDetail(title: .openTime, detail: rest.opentime),
            RestDetail(title: .holiday, detail: rest.holiday),
            RestDetail(title: .address, detail: rest.address),
        ]
        return list.flatMap{ $0 }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return detailList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "RestTitleCell") as! RestTitleCell
            titleCell.setupCell(rest: rest)
            return titleCell
        case 1:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell") as! RestDetailCell
            let detail = detailList[indexPath.row]
            detailCell.setupCell(withTitle: detail.title, detail: detail.detail)
            return detailCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        case 1:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return NSLocalizedString("基本情報", comment: "")
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailPair = detailList[indexPath.row]
        if detailPair.isCallNumber {
            let phoneNum = detailPair.detail
            guard let telURL = URL(string: "tel:\(phoneNum)") else {
                return
            }
            let alert = UIAlertController(title: phoneNum, message: "に電話を発信しますか？", preferredStyle: .alert)
            let call = UIAlertAction(title: "はい", style: .default, handler: { action in
                UIApplication.shared.openURL(telURL)
            })
            alert.addAction(call)
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}
