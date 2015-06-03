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

class FeedRequest: NSObject {
    
    var bookFinder = ApiBook()
    var delegate:FeedRequestDelegate?
    var feedArray:[FeedObject]!
    var interval: Int
    var feedQuantity: Int
    var isRequesting: Bool
    var locationsFound: Int
    var usersFound: Int
    var bookListFound: Int
    var fetchCount: Int
    
    init(interval:Int) {
        self.interval = interval
        self.feedQuantity = 0
        
        isRequesting = false
        locationsFound = 0
        usersFound = 0
        bookListFound = 0
        fetchCount = 0
        
        feedArray = [FeedObject]()

    }
    
    func receiveFeedLocations(userLocation:CLLocation) {
        
        self.feedArray.removeAll(keepCapacity: true)
        
        fetchCount = 0
        isRequesting = true
        feedQuantity = interval
        
        var publicData = CKContainer.defaultContainer().publicCloudDatabase
                
        var query = CKQuery(recordType: "UserLocation", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray:nil))
        query.sortDescriptors = [CKLocationSortDescriptor(key: "Location", relativeLocation: userLocation)]
        
        publicData.performQuery(query, inZoneWithID: nil)  { (records:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                for var index = 0; index < records.count && index < self.feedQuantity; index++ {
                    
                    let record = records[index] as! CKRecord
                    
                    var newFeed = FeedObject()
                    newFeed.userID = record.valueForKey("UserID") as? String
                    newFeed.userLocation = record.valueForKey("Location") as? CLLocation
                    
                    self.feedArray.append(newFeed)
                }
                
                self.feedQuantity = self.feedArray.count
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.fillUserAndBookInformations()
                }
                
            }
        }
        
        
        
//        var queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = feedQuantity
//        
//        queryOperation.recordFetchedBlock = { (record:CKRecord!) in
//            
//            if record != nil {
//                self.fetchCount++
//                
//                var newFeed = FeedObject()
//                newFeed.userID = record.valueForKey("UserID") as? String
//                newFeed.userLocation = record.valueForKey("Location") as? CLLocation
//                
//                self.feedArray.append(newFeed)
//                
//                if(self.fetchCount == self.interval) {
//                    println("all fetchs done")
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.fillUserAndBookInformations()
//                    }
//                }
//
//            }
//            
//            else if self.fetchCount < self.interval && self.fetchCount > 0 {
//                println("limit of fetchs")
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.fillUserAndBookInformations()
//                }
//            }
//            
//            
//        }
//        
//        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor!, error: NSError!) in
//            
//            if cursor != nil {
//                
//                println("cursor")
//                
//                let newOperation = CKQueryOperation(cursor: cursor)
//                newOperation.recordFetchedBlock = queryOperation.recordFetchedBlock
//                newOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
//                newOperation.resultsLimit = 2
//                publicData.addOperation(newOperation)
//            }
//            
//            else {
//                println("cursor nil")
//                println(error)
//            }
//        }
//        
//        publicData.addOperation(queryOperation)
    }
    
    
    private func userBooks(userIdentifier: String!, feedObject:FeedObject) {
        
        var query = CKQuery(recordType: "Book", predicate: NSPredicate(format: "UserID = %@", userIdentifier))
        
        var publicData = CKContainer.defaultContainer().publicCloudDatabase
        
        publicData.performQuery(query, inZoneWithID: nil) { (records:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                for var index = 0; index < records.count; index++ {
                    
                    var record: CKRecord = records[index] as! CKRecord
                    
                    var newBook = Book()
                    newBook.apiLink = record.valueForKey("APILink") as! String
                    newBook.name = record.valueForKey("Name") as! String
                    
                    var photo = self.getBookPhoto(record, key: "CoverPhoto")
                        
                    if photo != nil {
                        newBook.coverPhoto = photo
                    }
                    
                    feedObject.bookArray.append(newBook)
                }
            }
            
            else {
                println("book error")
            }
        }
    }
    
    private func getBookPhoto(record:CKRecord, key:String) ->UIImage? {
        
        if let asset:CKAsset = record.objectForKey(key) as? CKAsset {
            if let data: NSData = NSData(contentsOfURL: asset.fileURL) {
                return UIImage(data: data)
            }
        }
        
        return nil
    }
    
    
    private func fillUserAndBookInformations() {
        
        var x = feedQuantity - interval
        
        if x < 0{
            x = 0
        }
        
        for ; x < feedArray.count; x++ {
            var location = LocationObject(location: feedArray[x].userLocation)
            location.locationInformations()
            feedArray[x].locationObject = location
            
            var user = User()
            user.name = ""
            user.userFromID(feedArray[x].userID)
            feedArray[x].user = user
            
            userBooks(feedArray[x].userID, feedObject:feedArray[x])
        }
        
        self.delegate?.feedInformationCompeted(self.feedArray)
        
    }
}
