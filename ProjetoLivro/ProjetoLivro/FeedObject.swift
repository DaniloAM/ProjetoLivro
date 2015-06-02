//
//  FeedObject.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 01/06/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class FeedObject: NSObject {

    var user: User?
    var locationObject: LocationObject?
    var userID:String?
    var userLocation:CLLocation?
    var bookArray:[String]?
    
    
    override init() {
        
    }
    
    
}
