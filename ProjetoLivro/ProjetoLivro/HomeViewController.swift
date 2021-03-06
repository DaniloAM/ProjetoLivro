//
//  HomeViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var profileButton: UIBarButtonItem!

    let cellSpacement = 2.0
    
    var feedScrollView:FeedScrollView!
    var locationManager:CLLocationManager!
    var numberOfFeeds: Int!
    
    override func viewWillAppear(animated: Bool) {
        
        var status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            feedScrollView.requestOffers(locationManager.location)
            locationManager.stopUpdatingLocation()
        }
            
        else {
            var alertController = UIAlertController(title: "Problema de localização.", message: "A opção de localização está desativada. Por favor, ative para adicionar locais para troca de livros", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfFeeds = 10
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        createFeedScrollView()

    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            feedScrollView.requestOffers(locationManager.location)
            locationManager.stopUpdatingLocation()
        }
            
        else {
            var alertController = UIAlertController(title: "Problema de localização.", message: "A opção de localização está desativada. Por favor, ative para adicionar locais para troca de livros", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
           
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        
    }
    
    
    private func createFeedScrollView() {
        
        let barSize = 0.0
        let cellSize = self.view.frame.size.height / CGFloat(5.0)
        
        var frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CGFloat(self.view.frame.size.height - CGFloat(barSize)))
        
        feedScrollView = FeedScrollView(frame: frame, superview: self.view)
        self.view.addSubview(feedScrollView)
        
        feedScrollView.showsVerticalScrollIndicator = false
        feedScrollView.backgroundColor = UIColor(red: 38 / 255, green: 61 / 255, blue: 79 / 255, alpha: 1.0)
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "showProfile" {
            if (!checkUserLogged()){
                return false
            }
        }
        
        // by default, transition
        return true
    }
    
    func checkUserLogged() -> Bool {
        var id = ""
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
        if (userDefaults.objectForKey("UserID") != nil) {
            id = userDefaults.stringForKey("UserID")!
        }
        
        if (isEmpty(id)){
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
            //self.showViewController(secondViewController, sender: false)
            return false
        }
        
        return true
    }
    
    private func isEmpty(val: String) -> Bool{
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed = val.stringByTrimmingCharactersInSet(whitespace)
        return count(trimmed) == 0
    }
}

