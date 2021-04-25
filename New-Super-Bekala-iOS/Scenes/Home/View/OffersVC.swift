//
//  OffersVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    @IBOutlet weak var specialOffersCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var specialOffersStack: UIStackView!
    @IBOutlet weak var filtersCollection: UICollectionView!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var stackHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var specialOffersView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFilterCollection()
        loadOffersTable()
        loadSpecialOffersCollection()
    }
    
    func loadSpecialOffersCollection(){
        
        specialOffersCollection.numberOfItemsInSection { (_) -> Int in
            return 1
        }.cellForItemAt { (index) -> UICollectionViewCell in
            
            let cell = self.specialOffersCollection.dequeueReusableCell(withReuseIdentifier: "SpecialOffersCell", for: index) as! SpecialOffersCollectionViewCell
            return cell
            
        }
        
    }

    func loadFilterCollection(){
        
        if let flowLayout = filtersCollection!.collectionViewLayout as? UICollectionViewFlowLayout {
           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        let nib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        filtersCollection.register(nib, forCellWithReuseIdentifier: "FilterCollectionViewCell")
        
        filtersCollection.numberOfItemsInSection { (_) -> Int in
            return 10
        }.cellForItemAt { (index) -> UICollectionViewCell in
            
            let cell = self.filtersCollection.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: index) as! FilterCollectionViewCell
            return cell
            
        }.sizeForItemAt { (_) -> CGSize in
            return CGSize(width: 120, height: self.filtersCollection.frame.height)
        }
        
    }
    
    func loadOffersTable(){
        
        let nib = UINib(nibName: "OffersTableViewCell", bundle: nil)
        offersTableView.register(nib, forCellReuseIdentifier: "OffersCell")
        
        offersTableView.numberOfRows { (_) -> Int in
            return 5
        }.cellForRow { (index) -> UITableViewCell in
            
            let cell = self.offersTableView.dequeueReusableCell(withIdentifier: "OffersCell", for: index) as! OffersTableViewCell
            
            cell.loadUI()
            
            let onsaleCollection = cell.onsaleCollectionView
            
            let nib = UINib(nibName: "OnSaleCollectionViewCell", bundle: nil)
            onsaleCollection?.register(nib, forCellWithReuseIdentifier: "OnSaleCell")
            
            onsaleCollection?.numberOfItemsInSection(handler: { (_) -> Int in
                return 5
            }).cellForItemAt(handler: { (index) -> UICollectionViewCell in
                
                let cell = onsaleCollection?.dequeueReusableCell(withReuseIdentifier: "OnSaleCell", for: index) as! OnSaleCollectionViewCell
                cell.loadUI()
                return cell
                
            }).sizeForItemAt(handler: { (_) -> CGSize in
                return CGSize(width: 200, height: 250)
            })
            
            return cell
            
        }.heightForRowAt { (_) -> CGFloat in
            return 400
        }.didScroll { (scrollView) in
            
            if (scrollView.contentOffset.y == 0) {
                UIView.animate(withDuration: 0.3) {
                    self.pageControl.isHidden = false
                    self.stackHeightCnst.constant = 245
                    self.view.layoutIfNeeded()
                }
            }else{
                UIView.animate(withDuration: 0.3) {
                    self.pageControl.isHidden = true
                    self.stackHeightCnst.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }

}
