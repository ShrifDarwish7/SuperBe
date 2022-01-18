//
//  OffersVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension OffersVC: MainViewDelegate{

    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?) {
        offersTableView.hideSkeleton()
        if let data = data,
           !data.isEmpty,
           let meta = meta{
            DispatchQueue.main.async { [self] in
                self.meta = meta
                filtersCollection.isUserInteractionEnabled = true
                data.forEach { branch in
                    self.branches.append(branch)
                }
                page += 1
                self.isLoading = false
                self.offersTableView.hideSkeleton()
                let contentOffset = scrollView.contentOffset
                self.loadTbl()
                offersTableView.setContentOffset(contentOffset, animated: false)
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                activityIndicator.hidesWhenStopped = true
                offersTableView.tableFooterView = activityIndicator
                offersTableView.tableFooterView?.isHidden = false
                    //activityIndicator.startAnimating()
                if branches.count > 5{
                    activityIndicator.startAnimating()
                }else{
                    activityIndicator.stopAnimating()
                }
                isPaginting = false
            }
        }
    }
    func didCompleteWithSlider(_ data: [Slider]?, _ error: String?) {
        specialOffersCollection.hideSkeleton()
        if let data = data, !data.isEmpty{
            self.slider = data
        }else{
            specialOffersStack.isHidden = true
        }
    }
    func didCompleteWithBranchById(_ data: Branch?) {
        if let branch = data{
            Router.toBranch(self, branch)
        }
    }
}
