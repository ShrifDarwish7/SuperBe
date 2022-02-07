//
//  ProductVC+ScrollViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ProductVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = topViewHeight.constant - y
        if newHeaderViewHeight > maxHeaderViewHeight {
            topViewHeight.constant = maxHeaderViewHeight
            selectedProductView.isHidden = true
        } else if newHeaderViewHeight < minHeaderViewHeight {
            topViewHeight.constant = minHeaderViewHeight
            selectedProductView.isHidden = false
        } else {
            topViewHeight.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        selectedProductView.isHidden = true
        topViewHeight.constant = maxHeaderViewHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
