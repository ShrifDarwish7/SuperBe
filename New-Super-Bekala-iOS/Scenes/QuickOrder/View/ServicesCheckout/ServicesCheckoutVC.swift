//
//  ServicesCheckoutVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GoogleMaps
import AVFoundation
import MapKit

class ServicesCheckoutVC: UIViewController {
    
    @IBOutlet weak var pickupMapView: GMSMapView!
    @IBOutlet weak var pickupLandmark: UILabel!
    @IBOutlet weak var dropoffMapView: GMSMapView!
    @IBOutlet weak var dropoffLandmark: UILabel!
    @IBOutlet weak var voiceSlider: UISlider!
    @IBOutlet weak var currentDuration: UILabel!
    @IBOutlet weak var voiceLength: UILabel!
    @IBOutlet weak var pause_resume_btn: UIButton!
    @IBOutlet weak var recordContainerView: ViewCorners!
    @IBOutlet weak var imagesContainerView: ViewCorners!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var textContainerVew: ViewCorners!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var titleTop: UILabel!
    @IBOutlet weak var submitBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var superService: SuperService?
    var player : AVAudioPlayer?
    var timer : Timer?
    var currentPlayingTime : Float?
    var minutes : Int?
    var seconds : Int?
    var presenter: MainPresenter?
    var serviceType: ServiceType = .checkout

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        let pickupCamera = GMSCameraPosition(latitude: Double(superService!.pickupCoords?.split(separator: ",")[0] ?? "0.0")!, longitude: Double(superService!.pickupCoords?.split(separator: ",")[1] ?? "0.0")!, zoom: 19)
        pickupMapView.camera = pickupCamera
        
        let dropoffCamera = GMSCameraPosition(latitude: Double(superService!.dropOffCoords?.split(separator: ",")[0] ?? "0.0")!, longitude: Double(superService!.dropOffCoords?.split(separator: ",")[1] ?? "0.0")!, zoom: 19)
        dropoffMapView.camera = dropoffCamera
        
        pickupLandmark.text = superService?.pickupLandmark
        dropoffLandmark.text = superService?.dropOffLandmark
        
        if let voiceData = superService?.voice{
            
            self.recordContainerView.isHidden = false
            self.loadRecordFrom(data: voiceData)
            
        }else if let _ = superService?.images{
            
            self.imagesContainerView.isHidden = false
            self.loadImagesCollection()
            
        }else if let text = superService?.text{
            
            self.textContainerVew.isHidden = false
            self.text.text = text
            
        }
        
        if serviceType == .summary{
            submitBtn.isHidden = true
            titleTop.text = "#\(superService?.orderId ?? 000000)"
        }
        
        cancelBtn.isHidden = superService?.status == "processing" ? false : true

    }
    
    func loadRecordFrom(data: Data){
        do{
            
            player = try AVAudioPlayer(data: data)
            self.initPlayer()
            self.pause_resume_btn.onTap {
                self.play_pause()
            }
            
        }catch let err{
            print(err)
        }
    }
    
    func initPlayer(){
        
        guard player != nil else { return }
        player!.prepareToPlay()
        player!.volume = 1.0
        let audioLength = Int(player!.duration)
        minutes = Int(audioLength / 60)
        seconds = audioLength - minutes! * 60
        self.voiceLength.text = "\(minutes ?? 00):\(seconds ?? 00)"
        voiceSlider.maximumValue = Float(player!.duration)
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(setSliderValue), userInfo: nil, repeats: true)
        
    }
    
    @objc func setSliderValue(){
        
        guard player != nil else { return }
        
        if player?.isPlaying == false {
            
            pause_resume_btn.setImage(UIImage(named: "play-icon"), for: .normal)
            
        }else{
            
            pause_resume_btn.setImage(UIImage(named: "pause-1"), for: .normal)
            currentPlayingTime = Float((player?.currentTime)!)
            UIView.animate(withDuration: 0.05, animations: {
                self.voiceSlider.setValue(self.currentPlayingTime!, animated: true)
            }) { (_) in
                
            }
            updateTime()
            
        }
    }
    
    func updateTime(){
        
        guard player != nil else{ return }
        let currentTime = Int(player!.currentTime)
        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        currentDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    func play_pause(){
        
        if player?.isPlaying == false{
            
            pause_resume_btn.setImage(UIImage(named: "pause-1"), for: .normal)
            player?.play()
            
        }else{
            
            pause_resume_btn.setImage(UIImage(named: "play-icon"), for: .normal)
            player?.pause()
            
        }
        
    }
    
    @IBAction func openPickupInMaps(_ sender: Any) {
        self.openInMaps(coordinates: (superService?.pickupCoords) ?? "0.0")
    }
    
    @IBAction func openDropoffInMaps(_ sender: Any) {
        self.openInMaps(coordinates: (superService?.dropOffCoords) ?? "0.0")
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        self.presenter?.updateOrder(id: (superService?.orderId)!, prms: ["status": "cancelled"])
    }
    

    @IBAction func submitAction(_ sender: Any) {
        
        var parameters: [String: Any] = [:]
        var imagesPrms: [String: UIImage]?
        
        if let images = self.superService?.images{
            imagesPrms = [:]
            for i in 0...images.count-1{
                imagesPrms!.updateValue(images[i], forKey: "files[\(i)]")
            }
        }else if let notes = self.superService?.text{
            parameters.updateValue(notes, forKey: "notes")
        }
        
        parameters.updateValue(self.superService?.pickupCoords ?? "", forKey: "origin_coordinates")
        parameters.updateValue(self.superService?.dropOffCoords ?? "", forKey: "destination_coordinates")
        
        if let _ = superService?.pickupAddressId{
            parameters.updateValue((self.superService?.pickupAddressId)!, forKey: "origin_address_id")
        }else{
            parameters.updateValue(self.superService?.pickupLandmark ?? "", forKey: "origin_address")
        }
        
        if let _ = superService?.dropoffAddressId{
            parameters.updateValue((self.superService?.dropoffAddressId)!, forKey: "destination_address_id")
        }else{
            parameters.updateValue(self.superService?.dropOffLandmark ?? "", forKey: "destination_address")
        }
        
        parameters.updateValue("0", forKey: "payment_method")
    
        self.presenter?.placeSuperService(parameters, imagesPrms, self.superService?.voice)
    }
}

extension ServicesCheckoutVC: MainViewDelegate{
    func didCompletePlaceSuperService(_ error: String?,_ id: Int) {
        if let error = error{
            showToast(error)
        }else{
            Router.toOrderPlaced(self, id)
        }
    }
    func didCompleteUpdateOrder(_ data: LastOrder?, _ error: String?) {
        if let _ = data{
            self.navigationController?.popViewController(animated: true)
        }else{
            showToast(error!)
        }
    }
}

enum ServiceType{
    case checkout
    case summary
}
