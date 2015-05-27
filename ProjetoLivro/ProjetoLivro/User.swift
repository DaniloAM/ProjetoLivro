//
//  User.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 26/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class User: NSObject {
    var email:String!
    var name:String!
    var lastName:String!
    var password:String!
    var photo:UIImage!
    var userID:String?

    init(email:String!, name:String!, lastName:String!,password:String!,photo:UIImage!,userID:String?) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.photo = photo
        self.userID = userID
    }
    
    func checkUserValid() ->Bool {
        return true
    }
    
}
