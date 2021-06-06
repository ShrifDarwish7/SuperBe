//
//  BalanceVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class BalanceVC: UIViewController {

    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var balanceView: ViewCorners!
    
    var presenter: MainPresenter?
    var transactions: [Trans]?{
        didSet{
            loadFromNib()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(self)
        presenter?.getPoints()
    }

}

extension BalanceVC: UITableViewDelegate, UITableViewDataSource{
    func loadFromNib(){
        let nib = UINib(nibName: TransactionsTableViewCell.identifier, bundle: nil)
        transactionsTableView.register(nib, forCellReuseIdentifier: TransactionsTableViewCell.identifier)
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactions!.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        sectionView.backgroundColor = UIColor.clear

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        label.text = self.transactions![section].day
        label.alpha = 0.5
        sectionView.addSubview(label)
        
        return sectionView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions![section].trans.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier, for: indexPath) as! TransactionsTableViewCell
        cell.points.text = "\(self.transactions![indexPath.section].trans[indexPath.row].value)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension BalanceVC: MainViewDelegate{
    func didCompleteWithPoints(_ data: PointsData?, _ error: String?) {
        activityIndicator.stopAnimating()
        if let data = data,
           let points = data.total,
           let transactions = data.transactions{
            balanceView.isHidden = false
            balanceLbl.text = "\(points) EGP"
            var days = [String]()
            for trns in transactions{
                let date = String(trns.createdAt.split(separator: " ").first!)
                guard !days.contains(date) else {
                    continue
                }
                days.append(date)
            }
            
            days = days.sorted{ $0 > $1 }
            var trans = [Trans]()
            days.forEach { (day) in
                trans.append(Trans(day: day, trans: transactions.filter({ $0.createdAt.split(separator: " ").first! == day })))
            }
            self.transactions = trans
        }
    }
}

struct Trans{
    var day: String
    var trans: [PointTransaction]
}
