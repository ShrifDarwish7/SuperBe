//
//  ImagesOrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class ImagesOrderVC: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var addBtn: ViewCorners!
    
    var selectedImages = [UIImage]()
    var branch: Branch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadFromGallery(_ sender: Any) {
        
        let imagePicker = ImagePickerController()
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            var temp = [UIImage]()
            for asset in assets{

                let option = PHImageRequestOptions()
                option.deliveryMode = .highQualityFormat
                option.isSynchronous = true
                    
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in

                    guard let image = image else {return}
                    temp.append(image)
                }

            }
            
            self.addBtn.alpha = 1
            self.selectedImages = temp
            self.emptyLbl.isHidden = true
            self.loadImagesCollection()
            
        })
                    
    }
    
    @IBAction func openCamera(_ sender: Any) {
        
        UIImagePickerController(
            source: .camera,
            allow: [.image],
            cameraOverlay: nil,
            showsCameraControls: true) { result,picker in
            self.addBtn.alpha = 1
            self.selectedImages.append((result.originalImage ?? UIImage()))
            self.emptyLbl.isHidden = true
            self.loadImagesCollection()
            
        }.didCancel { [weak self] in
            self?.dismiss(animated: true)
        }.present(from: self)
        
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        guard !selectedImages.isEmpty else { return }
        var product = Product()
        product.photos = selectedImages
        product.branch = branch
        CartServices.shared.addToCart(product) { (completed) in
            if completed{
                self.navigationController?.popViewController(animated: true)
            }
        } exist: { (_) in
            
        }

    }
    
    
}
