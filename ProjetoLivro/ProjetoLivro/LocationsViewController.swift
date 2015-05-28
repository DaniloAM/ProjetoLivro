//
//  LocationsViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, CLLocationManagerDelegate, UIAlertViewDelegate {

    var locationManager:CLLocationManager!
    var canGiveLocation: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canGiveLocation = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            canGiveLocation = true
        }
    }
    
    @IBAction func createLocation(sender: AnyObject) {
        
        if canGiveLocation == true {
            locationManager.startUpdatingLocation()
            locationManager.location.coordinate
            
            var geoCoder = CLGeocoder()
            var newLocation = LocationObject()
            
            newLocation.location = locationManager.location
            
            geoCoder.reverseGeocodeLocation(self.locationManager.location, completionHandler: { (placemarks, error) -> Void in
                let placeArray = placemarks as! [CLPlacemark]
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray[0]
                
                // Address dictionary
                println(placeMark.addressDictionary)
                
                // Location name
                if let locationName = placeMark.addressDictionary["Name"] as? String {
                    newLocation.locationName = locationName
                }
                
                // Street address
//                if let street = placeMark.addressDictionary["Thoroughfare"] as? NSString {
//                    println(street)
//                }
                
                // City
                if let city = placeMark.addressDictionary["City"] as? String {
                    newLocation.city = city
                }
                
                // Country
                if let country = placeMark.addressDictionary["Country"] as? String {
                    newLocation.country = country
                }
            })
        }
        
        else {
            var alertView = UIAlertView(title: "Problema de localização.", message: "A opção de localização está desativada. Por favor, ative para adicionar locais para troca de livros", delegate: self, cancelButtonTitle: "Ok")
   
            alertView.show()
        }
        
    }

}
