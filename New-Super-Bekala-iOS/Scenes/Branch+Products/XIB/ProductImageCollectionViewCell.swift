//
//  ProductImageCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    static let identifier = "ProductImageCollectionViewCell"
    
    @IBOutlet weak var productImg: UIImageView!
    
    var startingImageView : UIImageView?
    var blackBgView : UIView?
    var startingFrame : CGRect?
    var zoomingImageView : UIImageView?
    var scrollView: UIScrollView?
    
    func loadImageGestures(){
        productImg.isUserInteractionEnabled = true
        productImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(tapGesture:))))
    }
    
    @objc func handleGesture(tapGesture : UITapGestureRecognizer){
        if let startingFrame = tapGesture.view as? UIImageView{
            performZooming(startingImageView: startingFrame)
        }
    }
    
    func performZooming(startingImageView : UIImageView){
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView!.image = startingImageView.image
            zoomingImageView!.contentMode = .scaleAspectFit
            zoomingImageView!.isUserInteractionEnabled = true
            zoomingImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            if let keyWindow = UIApplication.shared.keyWindow {
                self.blackBgView = UIView(frame: keyWindow.frame)
                self.blackBgView?.backgroundColor = UIColor.black
                self.blackBgView?.alpha = 0
                
                self.scrollView = UIScrollView(frame: keyWindow.frame)
                self.scrollView?.delegate = self
                self.scrollView?.minimumZoomScale = 1
                self.scrollView?.maximumZoomScale = 6
                self.scrollView?.addSubview(zoomingImageView!)
                self.scrollView?.isHidden = false
                
                keyWindow.addSubview(blackBgView!)
                keyWindow.addSubview(scrollView!)

                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.blackBgView?.alpha = 1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    self.zoomingImageView!.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    self.zoomingImageView!.center = keyWindow.center
                    
                }) { (completed) in
                    // do nothing
                }
                
            }
            
        }
    
    @objc func handleZoomOut(sender : UITapGestureRecognizer){
            
            if let zoomOutImageView = sender.view{
                zoomOutImageView.layer.cornerRadius = 7
                zoomOutImageView.clipsToBounds = true
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    zoomOutImageView.frame = self.startingFrame!
                    self.blackBgView?.alpha = 0
                    
                }) { (completed) in
                    
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                    self.scrollView?.isHidden = true
                    
                }
                
            }
            
        }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return self.zoomingImageView
        }
    
}
