//
//  MapViewController.swift
//  Wander
//
//  Created by IOS on 4/28/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapV: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLat: Double = 0.0
    var currentLon: Double = 0.0
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapV.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        /*let location = CLLocationCoordinate2D(latitude: Double("23.5379682")!,longitude: Double("87.289846")!)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapV.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "IGLOBAL IMPACT ITES PVT. LTD."
        annotation.subtitle = "Durgapur, WB, India"
        mapV.addAnnotation(annotation)
        self.mapV.delegate = self
        
        let sourceLocation = CLLocationCoordinate2D(latitude: Double("23.5379682")!,longitude: Double("87.289846")!)
        let destinationLocation = CLLocationCoordinate2D(latitude:Double("12.9542946")! , longitude:Double("77.4908547")!)
        
        let sourcePin = customPin(pinTitle: "Durgapur", pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: "Bangalore", pinSubTitle: "", location: destinationLocation)
        self.mapV.addAnnotation(sourcePin)
        self.mapV.addAnnotation(destinationPin)
        
        let directionRequest = MKDirectionsRequest()
        if #available(iOS 10.0, *) {
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation))
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
        } else {
            // Fallback on earlier versions
        }
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = directionResonse.routes[0]
            self.mapV.add(route.polyline, level: .aboveRoads)
         
            let rect = route.polyline.boundingMapRect
            self.mapV.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLat = locValue.latitude
        currentLon = locValue.longitude
        print("locations = \(currentLat) \(currentLon)")
        setupPolyline()
    }
    
    func setupPolyline() {
        /*let sourceLocation = CLLocationCoordinate2D(latitude: 23.5379682, longitude: 87.289846)
         let destinationLocation = CLLocationCoordinate2D(latitude: 23.4943454, longitude: 87.3147216)
         let sourceLocation = CLLocationCoordinate2D(latitude: 42.7176947, longitude: -73.2256683)
         let destinationLocation = CLLocationCoordinate2D(latitude: 40.7127753, longitude: -74.0059728)*/
        
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLon)
        let destinationLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "SOURCE"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "DESTINATION"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        mapV.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapV.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapV.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2.0
        return renderer
    }
}
