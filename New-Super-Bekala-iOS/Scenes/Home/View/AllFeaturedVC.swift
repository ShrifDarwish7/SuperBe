//
//  AllFeaturedVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/11/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class AllFeaturedVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var allCollectionView: UICollectionView!
    
    var branches: [Branch]?
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(self)
        allCollectionView.delegate = self
        allCollectionView.dataSource = self
        self.loadFeaturedCollection()
    }
   
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AllFeaturedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func loadFeaturedCollection(){
        let nib = UINib(nibName: FeaturedCollectionViewCell.identifier, bundle: nil)
        allCollectionView.register(nib, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)
        allCollectionView.delegate = self
        allCollectionView.dataSource = self
        allCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.branches!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.allCollectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as! FeaturedCollectionViewCell
        if let favBranches = Shared.favBranches,
           !favBranches.isEmpty,
           !favBranches.filter({ return $0.id == self.branches![indexPath.row].id}).isEmpty{
            self.branches![indexPath.row].isFavourite = 1
        }
        cell.loadFrom(data: self.branches![indexPath.row])
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(addToFavourite(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.toBranch(self, self.branches![indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func addToFavourite(sender: UIButton){
        if let favBranches = Shared.favBranches,
           !favBranches.isEmpty,
           !favBranches.filter({ return $0.id == self.branches![sender.tag].id}).isEmpty{
            let fav = favBranches.filter({ return $0.id == self.branches![sender.tag].id}).first
            presenter?.removeFromFavourites((fav?.favouriteId)!, sender.tag, true)
        }else{
            let prms = [
                "model_id": "\(self.branches![sender.tag].id)",
                "model": "Branch"
            ]
            self.presenter?.addToFavourite(prms, sender.tag, true)
        }
    }
}

extension AllFeaturedVC: MainViewDelegate{
    func didCompleteAddToFavourite(_ error: String?, _ index: Int?,_ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            if isFeatured!{
                self.branches![index!].isFavourite = 1
                let contentOffset = allCollectionView.contentOffset
                self.loadFeaturedCollection()
                allCollectionView.setContentOffset(contentOffset, animated: true)
            }
        }
    }
    
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            if isFeatured!{
                self.branches![index!].isFavourite = 0
                let contentOffset = allCollectionView.contentOffset
                self.loadFeaturedCollection()
                allCollectionView.setContentOffset(contentOffset, animated: true)
            }
        }
    }
}
