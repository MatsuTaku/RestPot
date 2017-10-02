//
//  RestDetailViewController.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/09.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit

enum RestDetailTableSection: Int {
    case Title = 0
    case Detail
}

class RestDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rest: Restaulant!
    lazy var detailList: [RestDetail] = self.rest.dataList as! [RestDetail]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        AppIconWhiteImageView.set(to: navigationItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension RestDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch RestDetailTableSection(rawValue: section) {
        case .some(.Title): return 1
        case .some(.Detail): return detailList.count
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch RestDetailTableSection(rawValue: indexPath.section) {
        case .some(.Title):
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "RestTitleCell") as! RestTitleCell
            titleCell.setupCell(rest: rest)
            return titleCell
        case .some(.Detail):
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell") as! RestDetailCell
            let restDetail = detailList[indexPath.row]
            detailCell.setupCell(restDetail: restDetail)
            return detailCell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch RestDetailTableSection(rawValue: section) {
        case .some(.Title):
            return 0.1
        case .some(.Detail):
            return 30
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch RestDetailTableSection(rawValue: section) {
        case .some(.Title): return nil
        case .some(.Detail): return NSLocalizedString("基本情報", comment: "")
        case .none: return nil
        }
    }
    
}

extension RestDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailPair = detailList[indexPath.row]
        if !detailPair.isCallNumber { return }
        
        let phoneNum = detailPair.detail
        guard let telURL = URL(string: "tel:\(phoneNum)") else { return }
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
