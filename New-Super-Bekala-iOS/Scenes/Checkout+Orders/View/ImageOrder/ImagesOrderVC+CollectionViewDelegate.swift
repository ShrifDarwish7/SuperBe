//
//  ImagesOrderVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ImagesOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func loadImagesCollection(){
        let nib = UINib(nibName: ImagesCollectionViewCell.identifier, bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.identifier, for: indexPath) as! ImagesCollectionViewCell
        cell.imageView.image = selectedImages[indexPath.row]
        cell.removeImage.isHidden = false
        cell.removeImage.tag = indexPath.row
        cell.removeImage.addTarget(self, action: #selector(self.removeImage(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(self.imagesCollectionView.frame.width/3-10), height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func removeImage(sender: UIButton){

        imagesCollectionView.deleteItems(at: [IndexPath(row: sender.tag, section: 0)])
        selectedImages.remove(at: sender.tag)
        if selectedImages.count == 0{
            emptyLbl.isHidden = false
            self.addBtn.alpha = 0.5
        }
        imagesCollectionView.reloadData()

    }
    
}
