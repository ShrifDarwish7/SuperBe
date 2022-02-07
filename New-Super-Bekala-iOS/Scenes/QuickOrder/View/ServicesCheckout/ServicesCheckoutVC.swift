//
//  ServicesCheckoutVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import SVProgressHUD

class ServicesCheckoutVC: UIViewController {
    
    @IBOutlet weak var pickupLandmark: UILabel!
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
    @IBOutlet weak var pickupMapView: MKMapView!
    @IBOutlet weak var dropoffMapView: MKMapView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var scroller: UIScrollView!
    
    var superService: SuperService?
    var player : AVAudioPlayer?
    var timer : Timer?
    var currentPlayingTime : Float?
    var minutes : Int?
    var seconds : Int?
    var presenter: MainPresenter?
    var serviceType: ServiceType = .checkout
    var delegate: OrderUpdatedDelegate?
    var verifiedPhoneNumber: String?
    var loginPresenter: LoginViewPresenter?
    var setting: Setting?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter = LoginViewPresenter(loginViewDelegate: self)
        presenter = MainPresenter(self)
        loginPresenter?.getSetting()
        
        let pickupCoords = CLLocationCoordinate2D(latitude: Double(superService!.pickupCoords?.split(separator: ",")[0] ?? "0.0")!, longitude: Double(superService!.pickupCoords?.split(separator: ",")[1] ?? "0.0")!)
        let dropOffCoords = CLLocationCoordinate2D(latitude: Double(superService!.dropOffCoords?.split(separator: ",")[0] ?? "0.0")!, longitude:Double(superService!.dropOffCoords?.split(separator: ",")[1] ?? "0.0")!)
        
        let pickupRegion = MKCoordinateRegion(center: pickupCoords, latitudinalMeters: 500, longitudinalMeters: 500)
        pickupMapView.region = pickupRegion
        
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = pickupCoords
        pickupMapView.addAnnotation(pickupAnnotation)
        
        let dropOffRegion = MKCoordinateRegion(center: dropOffCoords, latitudinalMeters: 500, longitudinalMeters: 500)
        dropoffMapView.region = dropOffRegion
        
        let dropOffAnnotation = MKPointAnnotation()
        dropOffAnnotation.coordinate = dropOffCoords
        dropoffMapView.addAnnotation(dropOffAnnotation)
        
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
        
        cancelBtn.isHidden = superService?.status == .processing ? false : true
        
        if let _ = APIServices.shared.user?.phoneVerifiedAt,
           let phone = APIServices.shared.user?.phone{
            self.verifiedPhoneNumber = phone
            self.phoneNumber.text = phone
        }else{
            self.verifiedPhoneNumber = nil
            self.phoneNumber.text = ""
        }
        
        if serviceType == .summary{
            submitBtn.isHidden = true
            titleTop.text = "#\(superService?.orderId ?? 000000)"
            phoneNumber.isUserInteractionEnabled = false
            phoneNumber.text = superService?.phoneNumber
        }
        
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
        delegate?.onRefreshOrders()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        self.presenter?.updateOrder(id: (superService?.orderId)!, prms: ["status": "cancelled"])
    }
    

    @IBAction func submitAction(_ sender: Any) {
        
        guard !phoneNumber.text!.isEmpty else {
            phoneStack.shake(.error)
            return
        }
        
        if let setting = setting, setting.skipOtpVerification == 0 {
            if self.phoneNumber!.text!.arToEnDigits != self.verifiedPhoneNumber?.arToEnDigits{
                guard self.phoneNumber.text?.count == 11 else{
                    showToast("Please make sure you entered a valid phone number".localized)
                    phoneStack.shake(.error)
                    return
                }
                SVProgressHUD.show()
                
                loginPresenter?.updateProfile([
                    "phone": self.phoneNumber.text!.arToEnDigits!
                ])
                return
            }
        }else{
            guard (self.phoneNumber.text?.count == 11) && (self.phoneNumber.text!.starts(with: "010") || self.phoneNumber.text!.starts(with: "011") || self.phoneNumber.text!.starts(with: "012") || self.phoneNumber.text!.starts(with: "015")) else{
                showToast("Please make sure you entered a valid phone number".localized)
                phoneStack.shake(.error)
                scroller.setContentOffset(phoneStack.frame.origin, animated: true)
                return
            }
        }
        
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
        parameters.updateValue((verifiedPhoneNumber ?? (phoneNumber.text?.arToEnDigits!))!, forKey: "phone")
    
        self.presenter?.placeSuperService(parameters, imagesPrms, self.superService?.voice)
    }
}

extension ServicesCheckoutVC: MainViewDelegate, LoginViewDelegate, PhoneVerifyDelegate{
    
    func didCompleteWithSetting(_ data: Setting?) {
        guard let setting = data else { return }
        self.setting = setting
    }
    
    func didCompleteUpdateProfile() {
        SVProgressHUD.dismiss()
        Router.toVerifyPhone(self, self.phoneNumber.text!)
    }
    
    func onVerify() {
        self.verifiedPhoneNumber = self.phoneNumber.text?.arToEnDigits
        self.submitAction(self)
    }
    
    func onCancelVerify() {
        if let _ = APIServices.shared.user?.phoneVerifiedAt,
           let phone = APIServices.shared.user?.phone{
            self.verifiedPhoneNumber = phone
            self.phoneNumber.text = phone
        }else{
            self.verifiedPhoneNumber = nil
            self.phoneNumber.text = ""
        }
    }
    
    func didCompletePlaceSuperService(_ error: String?,_ id: Int) {
        if let error = error{
            showToast(error)
        }else{
            Shared.selectedOrders = false
            Router.toOrderPlaced(UIApplication.getTopViewController()!, id)
//            let alert = UIAlertController(title: "Your order has been sent successfully".localized, message: "The order will be prepared and delivered to you as soon as possible .. Happy experience".localized, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: { (action) in
//                Router.toHome(self,false)
//            }))
//            present(alert,animated : true , completion : nil)
        }
    }
    
    func didCompleteUpdateOrder(_ data: LastOrder?, _ error: String?) {
        if let _ = data{
            delegate?.onRefreshOrders()
            if let _ = navigationController{
                self.navigationController?.popViewController(animated: true)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }else{
            showToast(error!)
        }
    }
}

enum ServiceType{
    case checkout
    case summary
}
