//
//  TagsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

protocol TagsDelegate{
    func onSelectTags(_ tags: [Tag])
}
class TagsVC: UIViewController {
    
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var moreBrn: UIButton!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    var delegate: TagsDelegate?
    var presenter: MainPresenter?
    var receivedTags: [Tag]?
    var tags: [Tag]?{
        didSet{
            tagsCollection.register(TagsCollectionViewCell.nib(), forCellWithReuseIdentifier: TagsCollectionViewCell.identifier)
            tagsCollection.delegate = self
            tagsCollection.dataSource = self
            tagsCollection.reloadData()
        }
    }
    var filters: [Tag]?{
        didSet{
            filtersCollection.register(TagsCollectionViewCell.nib(), forCellWithReuseIdentifier: TagsCollectionViewCell.identifier)
            filtersCollection.delegate = self
            filtersCollection.dataSource = self
            filtersCollection.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tags = receivedTags?.filter({ return $0.isFilter == 0 })
        self.filters = receivedTags?.filter({ return $0.isFilter == 1 })
        clearBtn.setTitle("Clear".localized, for: .normal)
    }
    
    @IBAction func colse(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            collectionHeight.constant = tagsCollection.contentSize.height
            sender.tag = 1
            sender.setTitle("Show Less".localized, for: .normal)
        case 1:
            collectionHeight.constant = 240
            sender.tag = 0
            sender.setTitle("Show More".localized, for: .normal)
        default: break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let tags = tags!.filter({ return $0.selected })
        let filters = filters!.filter({ return $0.selected })
        var selected = tags
        filters.forEach { tag in
            selected.append(tag)
        }
        delegate?.onSelectTags(selected)
    }
    
    @IBAction func clear(_ sender: Any) {
        for i in 0...tags!.count-1{
            tags![i].selected = false
        }
        for i in 0...filters!.count-1{
            filters![i].selected = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            UIView.animate(withDuration: 0.2) {
                self.clearBtn.isHidden = true
            }
        }
    }
    
    
}

extension TagsVC: MainViewDelegate{
    func didCompleteWithTags(_ data: [Tag]?, _ error: String?) {
        if let error = error {
            showToast(error)
        }else{
            self.tags = data
        }
    }
}

extension TagsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tagsCollection:
            return tags!.count
        case filtersCollection:
            return filters!.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case tagsCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionViewCell.identifier, for: indexPath) as! TagsCollectionViewCell
            cell.loadFrom(tags![indexPath.row])
            return cell
        case filtersCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionViewCell.identifier, for: indexPath) as! TagsCollectionViewCell
            cell.loadFrom(filters![indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case tagsCollection:
            return CGSize(width: 85, height: 115)
        case filtersCollection:
            return CGSize(width: 85, height: 115)
        default: return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case tagsCollection:
            tags![indexPath.row].selected = !tags![indexPath.row].selected
        case filtersCollection:
            filters![indexPath.row].selected = !filters![indexPath.row].selected
        default: break
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            UIView.animate(withDuration: 0.2) {
                if self.tags!.filter({ return $0.selected }).isEmpty, self.filters!.filter({ return $0.selected }).isEmpty{
                    self.clearBtn.isHidden = true
                }else{
                    self.clearBtn.isHidden = false
                }
            }
        }
    }
}
