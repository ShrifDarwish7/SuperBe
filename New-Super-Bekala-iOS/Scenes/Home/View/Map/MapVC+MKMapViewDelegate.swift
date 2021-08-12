//
//  MapVC+MKMapViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 07/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MapKit

extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = self.getCenterLocation(for: mapView)
                
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
        
        if zoomFactor > 1{
            self.showHintZoom()
        }else{
            self.dismissHintZoom()
            
            if let polygon = self.polygone{
                let polygonRenderer = MKPolygonRenderer(polygon: polygon)
                let mapPoint: MKMapPoint = MKMapPoint(CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude))
                let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
                if !polygonRenderer.path.contains(polygonViewPoint){
                    markerImageView.alpha = 0.5
                    self.inRegion = false
                    return
                }else{
                    self.inRegion = true
                    markerImageView.alpha = 1
                }
            }
            
            guard let previousLocation = self.previousLocation else { return }
            guard center.distance(from: previousLocation) > 50 else { return }
            self.previousLocation = center
            
            CLGeocoder().reverseGeocodeLocation(center) { [weak self] placemarks, error in
                guard let self = self else { return }
                if let error = error{
                    print(error)
                    return
                }
                guard let placemark = placemarks?.first else { return }
                switch Shared.mapState{
                case .fetchLocation:
                    Shared.deliveringToTitle = (placemark.administrativeArea ?? "") + "(\((placemark.subAdministrativeArea ?? placemark.name) ?? placemark.thoroughfare ?? ""))"
                default : break
                }
                DispatchQueue.main.async {
                    self.locationLbl.text = "\(placemark.administrativeArea ?? "") \(placemark.subAdministrativeArea ?? "") \(placemark.name ?? "")"
                    self.cityTF.text = placemark.administrativeArea ?? ""
                    self.districtTF.text = (placemark.subAdministrativeArea ?? "") + " " + (placemark.name ?? "")
                    self.streetTF.text = (placemark.thoroughfare ?? "") + " " + (placemark.subThoroughfare ?? "")
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "Main")
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
