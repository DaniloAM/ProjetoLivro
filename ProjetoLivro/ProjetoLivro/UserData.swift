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
}
