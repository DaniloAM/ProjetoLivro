//
//  LocationsViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, LocationCreationDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    var locationManager:CLLocationManager!
    var newLocation:LocationObject?
    var canGiveLocation: Bool!
 
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canGiveLocation = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let str = UserData.sharedInstance.user?.userID {
            var location = LocationObject()
            location.delegate = self
            location.getLocationsOfUserID(str)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            canGiveLocation = true
        }
    }
    
    
    //MARK: TableView delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.sharedInstance.locationsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: textCellIdentifier)
        }
        
        
        let location = UserData.sharedInstance.locationsArray[indexPath.row]
        
        let str:String! = location.locationName! + " - " + location.city!
        
        println(str)
        
        cell!.textLabel?.text = str
        
        return cell!
    }
    
    
    //MARK: Buttons Action
    
    @IBAction func createLocation(sender: AnyObject) {
        
        newLocation = LocationObject()
        newLocation!.locationID = "New"
        newLocation!.delegate = self
        newLocation!.currentLocation()
        
    }
    
    //MARK: Methods
    
    func saveNewLocation(location:LocationObject) {
        
        var str:String! = "Sua localização é em " + location.locationName!
        str = str + ", " + location.city! + " - "
        str = str + location.country! + "?"
        
        var alertController = UIAlertController(title: "Localização", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: .Default) { (action) in
            
            UserData.sharedInstance.addUserLocation(location)
            self.tableView.reloadData()
            
            location.saveLocation()
            
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {

        }

        newLocation = nil
    }
    
    //MARK: LocationObject delegate
    
    func newUserDataLocation(location:LocationObject) {
        location.delegate = self
        location.locationInformations()
    }
    
    func locationCreated(location:LocationObject) {
        UserData.sharedInstance.addUserLocation(location)
        tableView.reloadData()
    }
    
    func locationError(error:NSError?, auxiliar:String?) {
        println("Error")
        println(error)
    }
    
    func locationInformationFound(location:LocationObject) {
        if location.locationID == newLocation?.locationID {
            saveNewLocation(location)
        }
        
        else {
            UserData.sharedInstance.addUserLocation(location)
            tableView.reloadData()
        }
    }
    
    func locationInformationNotFound() {
        
    }
    
    func permissionForLocationDenied() {
        
        var alertController = UIAlertController(title: "Problema de localização.", message: "A opção de localização está desativada. Por favor, ative para adicionar locais para troca de livros", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }

}
