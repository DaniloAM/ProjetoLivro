//
//  LocationObject.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 27/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class LocationObject: NSObject {
   
    var location:CLLocation!
    var country:String!
    var state:String!
    var city:String!
    var locationName:String!
    
    override init() {
        
    }
    init(location:CLLocation!,country:String!,state:String!,city:String!,locationName:String!) {
        self.location = location
        self.country = country
        self.state = state
        self.city = city
        self.locationName = locationName
    }
    
}
