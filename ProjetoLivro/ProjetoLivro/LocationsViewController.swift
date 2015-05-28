//
//  LocationsViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, LocationCreationDelegate, CLLocationManagerDelegate {

    
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
        
        self.view.userInteractionEnabled = false
        
        var newLocation = LocationObject()
        newLocation.delegate = self
        newLocation.currentLocation()
        
    }
    
    func saveNewLocation(location:LocationObject) {
        
        var str:String! = "Sua localização é em " + location.locationName!
        str = str + ", " + location.city! + " - "
        str = str + location.country! + "?"
        
        var alertController = UIAlertController(title: "Localização", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (action) in
            alertController.removeFromParentViewController()
        }
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: .Default) { (action) in
            location.saveLocation()
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {

        }

    }
    
    //MARK: LocationObject delegate
    
    func locationCreated(location:LocationObject) {
        UserData.sharedInstance.locationsArray.append(location)
    }
    
    func locationError(error:NSError?, auxiliar:String?) {
        println("Error")
        println(error)
    }
    
    func locationInformationFound(location:LocationObject) {
        saveNewLocation(location)
    }
    
    func locationInformationNotFound() {
        
    }
    
    func permissionForLocationDenied() {
        
        var alertController = UIAlertController(title: "Problema de localização.", message: "A opção de localização está desativada. Por favor, ative para adicionar locais para troca de livros", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }

}
