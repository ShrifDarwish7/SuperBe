//
//  LastOrderVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension LastOrderVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadFromNib(){
        if isLoading{
            let nib = UINib(nibName: OrdinaryVendorsSkeletonTableViewCell.identifier, bundle: nil)
            lastOrdersTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        }else{
            let nib = UINib(nibName: LastOrdersTableViewCell.identifier, bundle: nil)
            lastOrdersTableView.register(nib, forCellReuseIdentifier: LastOrdersTableViewCell.identifier)
        }
        lastOrdersTableView.isHidden = false
        lastOrdersTableView.delegate = self
        lastOrdersTableView.dataSource = self
        lastOrdersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : (Shared.selectedOrders ? lastOrders.count : lastServices.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier, for: indexPath) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: LastOrdersTableViewCell.identifier, for: indexPath) as! LastOrdersTableViewCell
            cell.loadFrom(Shared.selectedOrders ? self.lastOrders[indexPath.row] : self.lastServices[indexPath.row])
            cell.rateBtn.onTap { [self] in
                var order: LastOrder?
                order = Shared.selectedOrders ? lastOrders[indexPath.row] : lastServices[indexPath.row]
                guard order?.status == .completed else { return }
                Router.toRateOrder(self, (order?.branch?.id)!, (order?.id)!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Shared.selectedOrders{
            Router.toOrder(self, self.lastOrders[indexPath.row])
        }else{
            
            let order = self.lastServices[indexPath.row]
            let service = SuperService()
            service.orderId = order.id
            service.status = order.status
            service.pickupCoords = order.originCoords
            service.pickupLandmark = order.originAddress
            service.dropOffCoords = order.destinationCoords
            service.dropOffLandmark = order.destinationAddress
            service.phoneNumber = order.phone

            if let files = order.files, !files.isEmpty{
                if let ext = files.first?.fileExtension{
                    switch ext {
                    case ".jpeg",".png",".jpg":
                        
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                SVProgressHUD.show()
                            }
                            service.images = files.map({ UIImage(data: try! Data(contentsOf: URL(string: Shared.storageBase + $0)!))! })
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                Router.toSuperServicesSummary(self, service)
                            }
                            
                        }
                        
                    case ".m4a",".mp3":
                        
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                SVProgressHUD.show()
                            }
                            service.voice = files.map({ try! Data(contentsOf: URL(string: Shared.storageBase + $0)!) }).first
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                Router.toSuperServicesSummary(self, service)
                            }
                            
                        }
                        
                    default:
                        break
                    }
                }
            }else{
                service.text = order.customerNote
                Router.toSuperServicesSummary(self, service)
            }
            
        }
        
//        if let _ = self.lastOrders[indexPath.row].branch{
//
//            Router.toOrder(self, self.lastOrders[indexPath.row])
//
//        }else{
//
//            let order = self.lastOrders[indexPath.row]
//            let service = SuperService()
//            service.orderId = order.id
//            service.status = order.status
//            service.pickupCoords = order.originCoords
//            service.pickupLandmark = order.originAddress
//            service.dropOffCoords = order.destinationCoords
//            service.dropOffLandmark = order.destinationAddress
//
//            if let files = order.files, !files.isEmpty{
//                if let ext = files.first?.fileExtension{
//                    switch ext {
//                    case ".jpeg",".png",".jpg":
//
//                        DispatchQueue.global(qos: .background).async {
//                            DispatchQueue.main.async {
//                                SVProgressHUD.show()
//                            }
//                            service.images = files.map({ UIImage(data: try! Data(contentsOf: URL(string: Shared.storageBase + $0)!))! })
//                            DispatchQueue.main.async {
//                                SVProgressHUD.dismiss()
//                                Router.toSuperServicesSummary(self, service)
//                            }
//
//                        }
//
//                    case ".m4a",".mp3":
//
//                        DispatchQueue.global(qos: .background).async {
//                            DispatchQueue.main.async {
//                                SVProgressHUD.show()
//                            }
//                            service.voice = files.map({ try! Data(contentsOf: URL(string: Shared.storageBase + $0)!) }).first
//                            DispatchQueue.main.async {
//                                SVProgressHUD.dismiss()
//                                Router.toSuperServicesSummary(self, service)
//                            }
//
//                        }
//
//                    default:
//                        break
//                    }
//                }
//            }else{
//                service.text = order.customerNote
//                Router.toSuperServicesSummary(self, service)
//            }
//
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.viewWillLayoutSubviews()
        if indexPath.row == (Shared.selectedOrders ? lastOrders.count-1 : lastServices.count-1){
            self.page += 1
            guard self.page <= (self.meta?.totalPages)! else {
                lastOrdersTableView.tableFooterView?.isHidden = true
                return
            }
            self.parameters.updateValue("\(page)", forKey: "page")
            if Shared.selectedOrders{
                self.presenter?.getMyOrders(parameters)
            }else{
                self.presenter?.getMyServices(parameters)
            }
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let maxHeight: CGFloat = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 80
//        let minHeight: CGFloat = self.view.frame.height * 0.5
//        let y: CGFloat = scrollView.contentOffset.y
//        let newViewHeight = self.ordersViewHeight.constant + y
//        if newViewHeight > maxHeight{
//            self.ordersViewHeight.constant = maxHeight
//        }else if newViewHeight < minHeight{
//            self.ordersViewHeight.constant = minHeight
//        }else{
//            self.ordersViewHeight.constant = newViewHeight
//           // scrollView.contentOffset.y = 0
//        }
//    }
    
}
