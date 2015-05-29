//
//  UserData.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 28/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class UserData: NSObject {
   
    static let sharedInstance = UserData()
    
    var user: User?
    var locationsArray = [LocationObject]()
    
    override init() {
    
    }
    
    func addUserLocation(location:LocationObject) {
        
        
        for var index = 0; index < self.locationsArray.count; index++ {
            
            let compared = self.locationsArray[index]
            
            if location.locationID == compared.locationID {
                return
            }
        }
        
        self.locationsArray.append(location)
    }
}
