//
//  Book.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class Book: NSObject {
   
    // database properties
    var bookID:String!
    var apiLink:String!
    var stateID:String!
    var userPhoto:UIImage!
    
    // properties for screen
    var coverPhoto:UIImage!
    var name:String!
    var author:String!
    var publish:String!
    var synopsis:String!
    
}
