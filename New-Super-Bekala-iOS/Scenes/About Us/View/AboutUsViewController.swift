//
//  AboutUsViewController.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/11/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import Closures

class AboutUsViewController: UIViewController {

    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet var covers: [UIImageView]!
    @IBOutlet var downCovers: [UIImageView]!
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var muchMoreLabel: UILabel!
    @IBOutlet weak var sbLoader: UIImageView!
    @IBOutlet weak var welcomeMsgLabel: UILabel!
    
    var guideContent = [Guide]()
    var currentIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        skipBtn.layer.cornerRadius = 10
        guideContent.append(Guide(image: UIImage(named: "aboutUsImg1")!, header: "Butchers", subHeader: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exerc"))
        guideContent.append(Guide(image: UIImage(named: "aboutUsImg2")!, header: "Pharmacies", subHeader: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptat"))
        guideContent.append(Guide(image: UIImage(named: "aboutUsImg3")!, header: "Supermarkets", subHeader: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exerc"))
        guideContent.append(Guide(image: UIImage(named: "aboutUsImg4")!, header: "Restaurants", subHeader: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation "))
        loadCollection()
        
        nextBtn.onTap {
            
            if self.currentIndex < 3{
                
                self.currentIndex += 1
                self.imagesCollection.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                self.showCover(index: self.currentIndex)
                
            }else{
                self.goNext()
            }
            
        }
        
        previousBtn.onTap {
            
            if self.currentIndex < 4{
                
                self.currentIndex -= 1
                self.imagesCollection.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                self.showCover(index: self.currentIndex)
                
            }else{
                self.goNext()
            }
            
        }
        
        logo.transform = CGAffineTransform(rotationAngle: -100)
        
        skipBtn.onTap {
            Router.toLogin(self)
        }
        
    }
    
    func loadCollection(){
         
        imagesCollection.numberOfItemsInSection { _ in 
            return self.guideContent.count
        }.cellForItemAt { (index) -> UICollectionViewCell in
            
            let cell = self.imagesCollection.dequeueReusableCell(withReuseIdentifier: "AboutUsCell", for: index) as! AboutUsCollectionViewCell
            cell.image.image = self.guideContent[index.row].image
            
            return cell
            
        }.sizeForItemAt { (_) -> CGSize in
            return CGSize(width: self.imagesCollection.frame.width, height: self.imagesCollection.frame.height)
        }.willDisplay { (_, index) in
            
            self.currentIndex = index.row
            if index.row > 0{
                self.previousBtn.isHidden = false
            }else{
                self.previousBtn.isHidden = true
            }
            
            self.header.text = self.guideContent[index.row].header
            self.subHeader.text = self.guideContent[index.row].subHeader
            
        }
        self.imagesCollection.reloadData()
    }
    
    func showCover(index: Int){
        
        for cover in self.covers{
            
            UIView.animate(withDuration: 0.5) {
                cover.alpha = 0
            }
            
        }
        
        for down in self.downCovers{
            
            UIView.animate(withDuration: 0.5) {
                down.alpha = 0
            }
            
        }
        
        UIView.animate(withDuration: 0.5) {
            self.covers[index].alpha = 1
            self.downCovers[index].alpha = 1
        }
        
    }
    
    func goNext(){
        
        UIView.animate(withDuration: 0.5) {
            self.welcomeView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                
                self.muchMoreLabel.alpha = 0
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                    
                    self.sbLoader.alpha = 1
                    
                }) { (_) in
                    
                    UIView.animate(withDuration: 0.5) {
                        self.welcomeMsgLabel.alpha = 1
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
