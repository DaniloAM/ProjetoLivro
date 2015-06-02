//
//  Book.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit

protocol BookSearchDelegate {
    func bookFound(books:[Book])
}



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
    
    // database variables
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    var searchDelegate: BookSearchDelegate?
    
    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
    }
    
    func getUserBooks(userID:String!){
        
        var books:[Book] = []
        
        let query = CKQuery(recordType: "Book", predicate: NSPredicate(format: "UserID = %@", userID))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    // books found
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        for record in records{
                            var bookRecord = record as! CKRecord
                            var book = Book.new()
                            
                            book.bookID = bookRecord.recordID.recordName
                            book.apiLink = bookRecord.valueForKey("APILink") as! String
                            book.stateID = bookRecord.valueForKey("StateID") as! String
                            
                            // SET api image
                            
                            books.append(book)
                        }
                        
                        self.searchDelegate?.bookFound(books)
                    }
                }
            }
        }
    }
    
    
    
}
