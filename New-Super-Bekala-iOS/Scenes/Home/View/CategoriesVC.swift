//
//  CategoriesVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var parameters: [String: String]?
    var presenter: MainPresenter?
    var categories: [Category]?
    var delegate: ChooserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(self)
        //SVProgressHUD.show()
       // presenter?.getCategories(parameters!)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
    }
}

extension CategoriesVC: MainViewDelegate{
    func didCompleteWithCategories(_ data: [Category]?) {
        SVProgressHUD.dismiss()
        if let _ = data{
            self.categories = data
        }
    }
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagedCategoryCollectionViewCell.identifier, for: indexPath) as! ImagedCategoryCollectionViewCell
        cell.loadFrom(categories![indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onChoose(categories![indexPath.row].id!)
        navigationController?.popViewController(animated: false)
    }
}
