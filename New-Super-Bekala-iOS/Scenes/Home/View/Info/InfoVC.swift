//
//  InfoVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 07/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class InfoVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phonesTableView: UITableView!
    @IBOutlet weak var deliveryAreasTableView: UITableView!
    @IBOutlet weak var openAndCloseTime: UILabel!
    @IBOutlet weak var workingDaysStack: UIStackView!
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var day6: UILabel!
    @IBOutlet weak var day7: UILabel!
    @IBOutlet weak var phonesTblHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryAreasTblHeight: NSLayoutConstraint!
    @IBOutlet weak var branchStatusIcon: UIImageView!
    @IBOutlet weak var branchStatusLbl: UILabel!
    @IBOutlet weak var deliveryHours: UILabel!
    @IBOutlet weak var onlinePayStack: UIStackView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    var branch: Branch?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveBranch(sender:)), name: NSNotification.Name("SEND_BRANCH"), object: nil)
    }
    
    @objc func didReceiveBranch(sender: NSNotification){
        guard let userInfo = sender.userInfo as? [String: Any] else { return }
        self.branch = userInfo["branch"] as? Branch
        self.loadUI()
    }
    
    func loadUI(){
        
        branchName.text = "lang".localized == "en" ? branch?.name?.en : branch?.name?.ar
        bio.text = "lang".localized == "en" ? branch?.bio?.en : branch?.bio?.ar
        
        onlinePayStack.isHidden = branch?.onlinePayment == 1 ? false : true
        
        if branch?.isOpen == 1{
            branchStatusLbl.text = "Open now".localized
            branchStatusIcon.image = UIImage(named: "open_now")
        }else{
            branchStatusLbl.text = "Close now".localized
            branchStatusIcon.image = UIImage(named: "close_now")
        }
        
        deliveryHours.text = (branch?.deliveryStartTime ?? "") + " - " + (branch?.deliveryEndTime ?? "")
        
        let camera = GMSCameraPosition(latitude: Double((branch?.coordinates?.split(separator: ",")[0])!) ?? 0.0, longitude: Double((branch?.coordinates?.split(separator: ",")[1])!) ?? 0.0, zoom: 19)
        mapView.camera = camera
        address.text = branch?.street
        
        if branch?.useCustomTimes == 0{
            workingDaysStack.isHidden = true
            openAndCloseTime.isHidden = false
            openAndCloseTime.text = (branch?.openingTime ?? "") + " - " + (branch?.closingTime ?? "")
        }else{
            openAndCloseTime.isHidden = true
            workingDaysStack.isHidden = false
            
            let temp1 = (branch?.customOpenCloseTimes?.openingTimeSaturday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeSaturday ?? "")
            day1.text = "Saturday: ".localized + temp1
            
            let temp2 = (branch?.customOpenCloseTimes?.openingTimeSunday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeSunday ?? "")
            day2.text = "Sunday: ".localized + temp2
                
            let temp3 = (branch?.customOpenCloseTimes?.openingTimeMonday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeMonday ?? "")
            day3.text = "Monday: ".localized + temp3
            
            let temp4 = (branch?.customOpenCloseTimes?.openingTimeTuesday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeTuesday ?? "")
            day4.text = "Tuesday: ".localized + temp4
            
            let temp5 = (branch?.customOpenCloseTimes?.openingTimeWednesday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeWednesday ?? "")
            day5.text = "Wednesday: ".localized + temp5
            
            let temp6 = (branch?.customOpenCloseTimes?.openingTimeThursday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeThursday ?? "")
            day6.text = "Thursday: ".localized + temp6
                
            let temp7 = (branch?.customOpenCloseTimes?.openingTimeFriday ?? "") + " - " + (branch?.customOpenCloseTimes?.closingTimeFriday ?? "")
            day7.text = "Friday: ".localized + temp7
        }
        
        phonesTableView.delegate = self
        phonesTableView.dataSource = self
        
        deliveryAreasTableView.delegate = self
        deliveryAreasTableView.dataSource = self
        
        phonesTableView.reloadData()
        deliveryAreasTableView.reloadData()
        
        phonesTblHeight.constant = phonesTableView.contentSize.height + 45
        deliveryAreasTblHeight.constant = deliveryAreasTableView.contentSize.height + 45
    }
    
    @IBAction func forwardToMaps(_ sender: Any) {
        
        let latitude: CLLocationDegrees = Double((branch?.coordinates?.split(separator: ",")[0])!)!
        let longitude: CLLocationDegrees = Double((branch?.coordinates?.split(separator: ",")[1])!)!
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "lang".localized == "en" ? branch?.name?.en : branch?.name?.ar
        mapItem.openInMaps(launchOptions: options)
        
    }
    
}
