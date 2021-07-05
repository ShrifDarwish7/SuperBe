//
//  CustomImages.swift
//  Tujjar
//
//  Created by Sherif Darwish on 6/7/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import Foundation
import UIKit

class Images{
    
   static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension UIImageView{
    
    func makekCircular(){
        
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
        
    }
    
    func addBorder(){
        
        self.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 35
        
    }
    
}
