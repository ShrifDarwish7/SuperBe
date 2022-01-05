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
        presenter?.getWalletPoints()
    }
    
    
    @IBAction func addBalance(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("START_PAYMENT"), object: nil, userInfo: nil)
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
        let value = self.transactions![indexPath.section].trans[indexPath.row].value
        cell.points.text = "\(value ?? 0)"
        
        if value! < 0{
            cell.containerView.backgroundColor = #colorLiteral(red: 0.9880966544, green: 0.4059396982, blue: 0.4844449759, alpha: 1)
            cell.statusIcon.image = UIImage(named: "minus-1")
            cell.validStack.isHidden = true
        }else{
            cell.containerView.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.8941176471, blue: 0.6470588235, alpha: 1)
            cell.statusIcon.image = UIImage(named: "added")
            if let expireDateStr = self.transactions![indexPath.section].trans[indexPath.row].expireDate{
                cell.validStack.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let calendar = Calendar.current
                let date = calendar.startOfDay(for: dateFormatter.date(from: expireDateStr)!)
                let components = calendar.dateComponents([.day], from: date, to: Date())
                cell.time.text = "\((components.day ?? 0) * (-1)) " + "Days".localized
            }else{
                cell.validStack.isHidden = true
            }
        }
        
        cell.expireView.isHidden = self.transactions![indexPath.section].trans[indexPath.row].isExpired == 0 ? true : false
        
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
