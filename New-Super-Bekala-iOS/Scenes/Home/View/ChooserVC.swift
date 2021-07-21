//
//  ChooserVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 17/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ChooserVC: UIViewController {

    @IBOutlet weak var optionsTableView: UITableView!
    
    var list: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        optionsTableView.reloadData()
    }
    
    @IBAction func close(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChooserVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.list![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DID_CHOOSE_OPTION"), object: nil, userInfo: ["index": indexPath.row])
    }
}
