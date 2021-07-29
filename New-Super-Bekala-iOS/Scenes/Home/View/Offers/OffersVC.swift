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
    @IBOutlet weak var specialOffersView: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: MainPresenter?
    var cartItems: [CartItem]?
    var page = 1
    var parameters: [String:String] = [:]
    var selectedCategory: Category?
    var meta: Meta?
    var branches = [Branch]()
    var isLoading = true
    var isPaginting = false
    var sliderIsLoading = true
    var slider: [Slider]?{
        didSet{
            pageControl.isHidden = false
            pageControl.numberOfPages = slider!.count
            pageControl.onChange { (page) in
                self.specialOffersCollection.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
            }
            sliderIsLoading = false
            specialOffersCollection.reloadData()
            performAutoSliding()
        }
    }
    var categories: [Category]?{
        didSet{
            self.loadFiltersCollection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
//        if Shared.isRegion{
//            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
//            if Shared.selectedArea.subregionID != 0{
//                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
//            }
//        }else if Shared.isCoords{
//            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
//        }
        
        presenter?.getSlider(["region_id": "1", "lang": "all"])
        parameters.updateValue("1", forKey: "offers_only")
        parameters.updateValue("all", forKey: "lang")
        self.presenter?.getCategories(parameters)
        showSkeletonView()
        
        let nib = UINib(nibName: ProductSkeletonCollectionViewCell.identifier, bundle: nil)
        specialOffersCollection.register(nib, forCellWithReuseIdentifier: ProductSkeletonCollectionViewCell.identifier)
        self.specialOffersCollection.reloadData()
        specialOffersCollection.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight.constant = offersTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    func showSkeletonView(){
        offersTableView.hideSkeleton()
        isLoading = true
        loadTbl()
        offersTableView.isSkeletonable = true
        offersTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    func performAutoSliding(){
        var index = 0
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { [self] timer in
            index = index < slider!.count ? index : 0
            specialOffersCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            index += 1
        })
    }
    

}

extension OffersVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView{
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                guard !self.branches.isEmpty else { return }
                guard page <= (self.meta?.totalPages)!, !isPaginting else {
                    print("end of paginating ", page)
                   // offersTableView.tableFooterView?.isHidden = true
                    return
                }
                self.offersTableView.tableFooterView?.isHidden = false
                DispatchQueue.global(qos: .background).async {
                    self.isPaginting = true
                    self.updateBranches()
                }
            }
        }

    }
}
