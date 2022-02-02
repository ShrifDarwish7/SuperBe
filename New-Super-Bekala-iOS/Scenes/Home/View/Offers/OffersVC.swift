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
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var scroller: UIScrollView!
    
    var presenter: MainPresenter?
    var cartItems: [CartItem]?
    var offersTabs = [OffersTab(name: "Offers".localized, image: UIImage(named: "discount")!, selected: true),
                      OffersTab(name: "Special".localized, image: UIImage(named: "sale")!, selected: false),
                      OffersTab(name: "Coupons".localized, image: UIImage(named: "coupon")!, selected: false)]
    var page = 1
    var parameters: [String:String] = [:]
   // var selectedCategory: Category?
    var meta: Meta?
    var branches = [Branch]()
    var isLoading = true
    var isPaginting = false
    var sliderIsLoading = true
    var refreshControl: UIRefreshControl!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollection.isUserInteractionEnabled = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        presenter = MainPresenter(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("SCROLL_TO_TOP"), object: nil)

        if Shared.isRegion{
            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
            if Shared.selectedArea.subregionID != 0{
                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
            }
        }else if Shared.isCoords{
            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
        }
        
        presenter?.getSlider(["city_id": "171", "lang": "all"])
        showSkeletonView()
        
        let nib = UINib(nibName: ProductSkeletonCollectionViewCell.identifier, bundle: nil)
        specialOffersCollection.register(nib, forCellWithReuseIdentifier: ProductSkeletonCollectionViewCell.identifier)
        self.specialOffersCollection.reloadData()
        specialOffersCollection.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        filtersCollection.register(OffersTabsCollectionViewCell.nib(), forCellWithReuseIdentifier: OffersTabsCollectionViewCell.identifier)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        
        parameters.updateValue("branchProducts.variations.options", forKey: "with")
        parameters.updateValue("\(page)", forKey: "page")
        parameters.updateValue("5", forKey: "per_page")
        parameters.updateValue("1", forKey: "offers_only")
        parameters.updateValue("all", forKey: "lang")
        
        switch self.offersTabs.filter({ return $0.selected }).first?.name {
        case "Offers".localized:
            presenter?.getBranches(parameters)
        case "Special".localized:
            presenter?.getOffers(parameters)
        case "Coupons".localized:
            presenter?.getCouponsOffers(parameters)
        default: break
        }
        
    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
        isLoading = true
        isPaginting = false
        sliderIsLoading = true
        page = 1
        branches.removeAll()
        self.viewDidLoad()
    }
    
    @objc func scrollToTop(){
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
            self.offersTableView.reloadData()
        }
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
//        let contentOffset = scroller.contentOffset
        self.tableHeight.constant = offersTableView.contentSize.height
        self.view.layoutIfNeeded()
       // self.scroller.setContentOffset(contentOffset, animated: true)
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
        _ = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [self] timer in
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
                    offersTableView.tableFooterView?.isHidden = true
                    return
                }
                self.offersTableView.tableFooterView?.isHidden = false
                DispatchQueue.global(qos: .background).async { [self] in
                    self.isPaginting = true
                    parameters.updateValue("\(page)", forKey: "page")
                    switch offersTabs.filter({ return $0.selected }).first?.name{
                    case "Offers".localized:
                        presenter?.getBranches(parameters)
                    case "Special".localized:
                        presenter?.getOffers(parameters)
                    case "Coupons".localized:
                        presenter?.getCouponsOffers(parameters)
                    default: break
                    }
                }
            }
        }

    }
}

struct OffersTab{
    var name: String
    var image: UIImage
    var selected: Bool
}
