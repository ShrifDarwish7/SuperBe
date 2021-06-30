//
//  ProductVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ProductVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadVariationTableView(){
        let nib = UINib(nibName: VariationsTableViewCell.identifier, bundle: nil)
        variationsTableView.register(nib, forCellReuseIdentifier: VariationsTableViewCell.identifier)
        variationsTableView.delegate = self
        variationsTableView.dataSource = self
        variationsTableView.reloadData()
       // variationTableViewHeight.constant = variationsTableView.contentSize.height + 15
      //  self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (product?.variations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VariationsTableViewCell.identifier, for: indexPath) as! VariationsTableViewCell
        let variation = product!.variations![indexPath.row]
        cell.variationName.text = "lang".localized == "en" ? variation.name?.en : variation.name?.ar
        cell.expandBtn.tag = indexPath.row
        cell.expandBtn.addTarget(self, action: #selector(expandVars(_:)), for: .touchUpInside)
        
        let selected = variation.options?.filter({ return $0.selected == true })
      //  let checked = variation.options?.filter({ return $0.checked == true })
        
        if selected!.isEmpty && variation.isAddition == 0{
            cell.chosedVariation.text = variation.isRequired == 1 ? "(Choose 1)".localized : "(Optional)".localized
        }else if selected!.isEmpty && variation.isAddition == 1{
            cell.chosedVariation.text = variation.isRequired == 0 ? "(Optional)".localized : ""
        }else if !selected!.isEmpty && variation.isAddition == 0{
            cell.chosedVariation.text = "lang".localized == "en" ? selected?.first?.name?.en : selected?.first?.name?.ar
        }else if !selected!.isEmpty && variation.isAddition == 1{
            var totalAdditions = 0
            selected?.forEach({ (option) in
                totalAdditions += option.price!
            })
            cell.chosedVariation.text = "+\(totalAdditions) EGP"
        }
        
//        if checked!.isEmpty && variation.isAddition == 1{
//            cell.chosedVariation.text = variation.isRequired == 0 ? "(Optional)".localized : ""
//        }else if !checked!.isEmpty{
//            var totalAdditions = 0
//            checked?.forEach({ (option) in
//                totalAdditions += option.price!
//            })
//            cell.chosedVariation.text = "+\(totalAdditions) EGP"
//        }
        
        var min_max = ""
        
        if let min = variation.min{
            min_max = "Min: \(min), "
            cell.min_max.isHidden = false
        }else{
            cell.min_max.isHidden = true
        }
        
        if let max = variation.max{
            min_max += "Max: \(max)"
            cell.min_max.isHidden = false
        }else{
            cell.min_max.isHidden = true
        }
        
        cell.min_max.text = min_max
        
        cell.optionsTableView.numberOfRows { [self] (_) -> Int in
            return (product?.variations?[indexPath.row].options?.count)!
        }.cellForRow { [self] (optionIndex) -> UITableViewCell in
            
            let nib = UINib(nibName: OptionsTableViewCell.identifier, bundle: nil)
            cell.optionsTableView.register(nib, forCellReuseIdentifier: OptionsTableViewCell.identifier)
            let option = product?.variations?[indexPath.row].options![optionIndex.row]
            let cell = cell.optionsTableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: optionIndex) as! OptionsTableViewCell
            cell.optionName.text = "lang".localized == "en" ? option?.name?.en : option?.name?.ar
            cell.price.isHidden = option?.price == 0 ? true : false
            cell.price.text = "\(option?.price ?? 0) EGP"
            cell.container.alpha = option?.inStock == 1 ? 1.0 : 0.3
            
            if let salePrice = option?.salePrice,
               salePrice != 0{
                cell.salePrice.text = "\(salePrice) EGP"
                cell.salePriceView.isHidden = false
            }else{
                cell.salePriceView.isHidden = true
            }
            
            if product?.variations?[indexPath.row].isAddition == 1 {
//                cell.radionImg.image = option?.checked == true ? UIImage(named: "checked") : UIImage(named: "unchecked")
                cell.radionImg.image = option?.selected == true ? UIImage(named: "checked") : UIImage(named: "unchecked")
            }else{
                cell.radionImg.image = option?.selected == true ? UIImage(named: "radio_selected") : UIImage(named: "radio_unselected")
            }
            return cell
            
        }.didSelectRowAt { (optionIndex) in
            
            //  guard self.product!.variations![indexPath.row].options![optionIndex.row].inStock == 1 else { return }
            UIView.animate(withDuration: 0.25) { [self] in
                
                if self.product?.variations?[indexPath.row].isAddition == 1 {
                    self.product!.variations![indexPath.row].options![optionIndex.row].selected = !(self.product!.variations![indexPath.row].options![optionIndex.row].selected)
//                    let options = self.product!.variations?[indexPath.row].options!.filter({ return $0.checked == true })
                    let options = self.product!.variations?[indexPath.row].options!.filter({ return $0.selected == true })
                    if let max = product?.variations![indexPath.row].max,
                       options!.count > max{
//                        self.product!.variations![indexPath.row].options![optionIndex.row].checked = !(self.product!.variations![indexPath.row].options![optionIndex.row].checked)
                        self.product!.variations![indexPath.row].options![optionIndex.row].selected = !(self.product!.variations![indexPath.row].options![optionIndex.row].selected)
                        return
                    }
                    var totalAdditions = 0
                    options?.forEach({ (option) in
                        totalAdditions += option.price!
                    })
                    cell.chosedVariation.text = "+\(totalAdditions) EGP"
                    
                }else{
                    
                    for i in 0...(self.product!.variations?[indexPath.row].options?.count)!-1{
                        self.product!.variations![indexPath.row].options![i].selected = false
                    }
                    self.product!.variations?[indexPath.row].options![optionIndex.row].selected = true
                    self.product!.variations![indexPath.row].expanded = false
                    let contentOffset = self.scroller.contentOffset
                    self.variationsTableView.reloadData()
                    self.view.layoutIfNeeded()
                    self.viewDidLayoutSubviews()
                    self.scroller.setContentOffset(contentOffset, animated: false)
                    let option = self.product!.variations?[indexPath.row].options![optionIndex.row]
                    cell.chosedVariation.text = "lang".localized == "en" ? option?.name?.en : option?.name?.ar
                    
                }
                
                self.popFlage = true
                cell.optionsTableView.reloadData()
                self.updateUI(indexPath.row)
            }
            
        }.heightForRowAt { (_) -> CGFloat in
            return 40
        }
        
        cell.optionsTableView.reloadData()
        
        if product!.variations![indexPath.row].expanded {
            cell.optionsContainer.alpha = 1
            cell.optionsTableViewHeight.constant = CGFloat(product!.variations![indexPath.row].options!.count * 40)
            UIView.animate(withDuration: 0.25) {
                cell.expandBtn.transform = CGAffineTransform(rotationAngle: .pi)
                self.view.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                cell.optionsTableViewHeight.constant = 0
                cell.optionsContainer.alpha = 0
                cell.expandBtn.transform = CGAffineTransform(rotationAngle: -(.pi*2))
                self.view.layoutIfNeeded()
            } completion: { (_) in
                
            }
        }
        
        self.viewWillLayoutSubviews()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if product!.variations![indexPath.row].isAddition == 1 && product!.variations![indexPath.row].isRequired != 1{
            for variation in product!.variations!{
                if variation.isRequired == 1{
                    guard !variation.options!.filter({ return $0.selected == true }).isEmpty else { return 0 }
                }
            }
        }
        
        if product!.variations![indexPath.row].expanded{
            return CGFloat(product!.variations![indexPath.row].options!.count * 40) + 140
        }else{
            return 75
        }
    }
    
    @objc func expandVars(_ sender: UIButton){
        product!.variations![sender.tag].expanded = !(product!.variations![sender.tag].expanded)
        let contentOffset = scroller.contentOffset
        self.variationsTableView.reloadData()
        self.view.layoutIfNeeded()
        self.viewDidLayoutSubviews()
        scroller.setContentOffset(contentOffset, animated: false)
    }
    
}
