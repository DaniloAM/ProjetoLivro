//
//  FeedRequest.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 01/06/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

protocol FeedRequestDelegate {
    func feedInformationError()
    func feedInformationCompeted(informations:[FeedObject])
    
}

class FeedRequest: NSObject, LocationCreationDelegate, UserIdentifierDelegate {
    
    var delegate:FeedRequestDelegate?
    var feedArray:[FeedObject]!
    var interval: Int
    var feedQuantity: Int
    var isRequesting: Bool
    var locationsFound: Int
    var usersFound: Int
    var bookListFound: Int
    
    init(interval:Int) {
        self.interval = interval
        self.feedQuantity = 0
        
        isRequesting = false
        locationsFound = 0
        usersFound = 0
        bookListFound = 0
        
        feedArray = [FeedObject]()

    }
    
    func receiveFeedLocations(userLocation:CLLocation) {
        
        isRequesting = true
        feedQuantity += interval
        
        var publicData = CKContainer.defaultContainer().publicCloudDatabase
                
        var query = CKQuery(recordType: "UserLocation", predicate: NSPredicate(format: "", argumentArray:nil))
        query.sortDescriptors = [CKLocationSortDescriptor(key: "Location", relativeLocation: userLocation)]
        
        var queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = feedQuantity
        
        queryOperation.recordFetchedBlock = { (record:CKRecord!) in
            
            if record != nil {
                
                var newFeed = FeedObject()
                newFeed.userID = record.valueForKey("UserID") as? String
                newFeed.userLocation = record.valueForKey("Location") as? CLLocation
                
                self.feedArray.append(newFeed)
                
                if(self.feedArray.count >= self.feedQuantity) {
                    self.fillUserAndBookInformations()
                }
            }
            
            
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor!, error: NSError!) in
            
            if cursor != nil {
                let newOperation = CKQueryOperation(cursor: cursor)
                newOperation.recordFetchedBlock = queryOperation.recordFetchedBlock
                newOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
                newOperation.resultsLimit = self.feedQuantity
                publicData.addOperation(newOperation)
            }
        }
        
        publicData.addOperation(queryOperation)
    }
    
    private func fillUserAndBookInformations() {
        
        for var x = feedQuantity - interval; x < feedQuantity; x++ {
            var location = LocationObject(location: feedArray[x].userLocation)
            location.delegate = self
            location.locationInformations()
            feedArray[x].locationObject = location
            
            var user = User()
            user.name = ""
            user.userIdentifierDelegate = self
            user.userFromID(feedArray[x].userID)
            feedArray[x].user = user
            
            //****BOOK******
            //var book = Book()
            
        }
        
    }
    
    func checkCompleteInformation() {
        if usersFound >= interval && locationsFound >= interval && bookListFound >= interval {
            
            self.delegate?.feedInformationCompeted(self.feedArray)
        }
    }
    
    //MARK: User Identifier Delegate
    
    func userFound(user:User!) {
        usersFound++
        checkCompleteInformation()
    }
    
    func userNotFound() {
        usersFound++
        checkCompleteInformation()
    }
    
    func userErrorNotFound(error:NSError!) {
        usersFound++
        checkCompleteInformation()
    }
    
    
    //MARK: Location Creation Delegate
    
    func locationInformationFound(location:LocationObject) {
        locationsFound++
        checkCompleteInformation()
    }
    
    func locationInformationNotFound() {
        locationsFound++
        checkCompleteInformation()
    }
}
