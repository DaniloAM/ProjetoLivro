//
//  LocationObject.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 27/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit

protocol LocationCreationDelegate {
    func locationCreated(location:LocationObject)
    func locationError(error:NSError?, auxiliar:String?)
    func locationInformationFound(location:LocationObject)
    func locationInformationNotFound()
    func permissionForLocationDenied()
    func newUserDataLocation(location:LocationObject)
}

class LocationObject: NSObject, CLLocationManagerDelegate {
   
    var userLocation:Bool!
    var locationManager: CLLocationManager!
    var location:CLLocation!
    var country:String?
    var state:String?
    var city:String?
    var locationName:String?
    var locationID:String?
    var streetName: String?
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    
    var delegate: LocationCreationDelegate?
    
    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
        locationManager = CLLocationManager()
        //locationManager.delegate = self
    }
    
    init(location:CLLocation!) {
        self.location = location
        
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
    }
    
    
    //Save location on iCloud
    func saveLocation() {
        
        let record = CKRecord(recordType: "UserLocation")
        
        locationID = record.recordID.recordName
        record.setValue(location, forKey: "Location")
        record.setValue(1, forKey: "IsFix")
        record.setValue(UserData.sharedInstance.user?.userID, forKey: "UserID")
        
        publicData.saveRecord(record, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
            //Error in recording
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.locationError(error,auxiliar: nil)
            }
        }
            
        else {
            //Creation successful
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.locationCreated(self)
            }
            }
        })
    }
    
    //Get all locations from user
    func getLocationsOfUserID(userID:String!) {
        
        var locations = [LocationObject]()
        
        let query = CKQuery(recordType: "UserLocation", predicate: NSPredicate(format: "UserID = %@", userID))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    for index in 0...records.count-1 {
                        
                        var record: CKRecord = records[index] as! CKRecord
                        
                        var newLocation = LocationObject(location: record.objectForKey("Location") as! CLLocation)
                        
                        newLocation.locationID = record.recordID.recordName
                        
                        self.delegate?.newUserDataLocation(newLocation)
                    }
                }
            }
            //Error case
            else {
                self.delegate?.locationError(error, auxiliar: nil)
            }
        }
    }
    
    //Get current location
    func currentLocation() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            location = locationManager.location
            locationInformations()
            locationManager.stopUpdatingLocation()
        }
            
        else {
            self.delegate?.permissionForLocationDenied()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    //Get location informatinos
    func locationInformations() {
        
        var geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
            if let placeArray = placemarks as? [CLPlacemark] {
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray[0]
                
                // Location name
                if let streetName = placeMark.addressDictionary["Locality"] as? String {
                    self.streetName = streetName
                }
                
                if let locationName = placeMark.addressDictionary["SubLocality"] as? String {
                    self.locationName = locationName
                }
                
                // City
                if let city = placeMark.addressDictionary["City"] as? String {
                    self.city = city
                }
                
                // Country
                if let country = placeMark.addressDictionary["Country"] as? String {
                    self.country = country
                }
                
                self.delegate?.locationInformationFound(self)
            }
                
            else {
                println("fail")
            }
        })
    }
    
}
