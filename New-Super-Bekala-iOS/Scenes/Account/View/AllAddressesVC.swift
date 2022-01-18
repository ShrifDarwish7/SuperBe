//
//  AllAddressesVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Be on 02/01/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD

class AllAddressesVC: UIViewController {

    @IBOutlet weak var addressesTableView: UITableView!
    
    var addresses: [Address]?
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        presenter = MainPresenter(self)
        addressesTableView.register(ProfileAddressesTableViewCell.nib(), forCellReuseIdentifier: ProfileAddressesTableViewCell.identifier)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.reloadData()
    }
    
    @IBAction func close(_ sender: Any) {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    

}

extension AllAddressesVC: MainViewDelegate, LoginViewDelegate{
    
    func didCompleteUpdateAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            SVProgressHUD.dismiss()
            self.presenter?.getAddresses()
        }
    }
    
    func didCompleteDeleteAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            SVProgressHUD.dismiss()
            self.presenter?.getAddresses()
        }
    }
    
    func didCompleteWithAddresses(_ data: [Address]?) {
        SVProgressHUD.dismiss()
        if let addresses = data{
            self.addresses = addresses
            addressesTableView.reloadData()
        }
    }
    
}


extension AllAddressesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAddressesTableViewCell.identifier, for: indexPath) as! ProfileAddressesTableViewCell
        cell.loadFrom(self.addresses![indexPath.row])
        
        cell.selectBtn.onTap {
            guard self.addresses![indexPath.row].selected == 0 else { return }
            self.presenter?.updateAddress(self.addresses![indexPath.row].id, ["selected": "1"])
        }
        
        cell.deleteBtn.onTap {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this address ?".localized, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { _ in
                SVProgressHUD.show()
                self.presenter?.deleteAddress(self.addresses![indexPath.row].id)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        cell.editBtn.onTap {
            Router.toEditAddreess(self, self.addresses![indexPath.row])
        }
        
        if self.addresses![indexPath.row].selected == 1{
            cell.selectBtn.tintColor = .systemGreen
            cell.selectBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }else{
            cell.selectBtn.tintColor = .black
            cell.selectBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
                
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
