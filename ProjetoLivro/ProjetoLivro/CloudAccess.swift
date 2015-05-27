//
//  CloudAccess.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 27/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit

class CloudAccess: NSObject {
    var container: CKContainer
    var publicData: CKDatabase
    var delegate: CloudAccessDelegate?
    
    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
    }
    
    func registerUser(user:User) {
        
        if user.checkUserValid() {
            
            let record = CKRecord(recordType: "User")
    
            record.setValue(user.name, forKey: "Name")
            record.setValue(user.lastName, forKey: "LastName")
            record.setValue(user.email, forKey: "Email")
            record.setValue(user.password, forKey: "Password")
            record.setValue(NSData(), forKey: "CreatedAt")
            record.setValue(NSData(), forKey: "UpdatedAt")
            addImageToRecord(record, image: user.photo, key: "Photo")
            
            publicData.saveRecord(record, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
                println(error)
                self.delegate?.userError(error,auxiliar: nil)
                self.delegate?.userRegistered(false)
            }
                
            else {
                    self.delegate?.userRegistered(true)
                }
            })
            
        }
    
    }
    
    func addImageToRecord(record:CKRecord,image:UIImage, key:String) ->Bool {
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let writePath = dirPath.stringByAppendingPathComponent("ImageUser.png")
                    UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
                    
                    var File : CKAsset?  = CKAsset(fileURL: NSURL(fileURLWithPath: writePath))
                    record.setValue(File, forKey: key)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func takeImageFromRecord(record:CKRecord, key:String) ->UIImage? {
        
        if let asset:CKAsset = record.objectForKey(key) as? CKAsset {
            if let data: NSData = NSData(contentsOfURL: asset.fileURL) {
                return UIImage(data: data)
                
            }
            
        }
        
        return nil
        
    }
    
    func searchForUser(email:String, password:String) ->User? {
        
        var newUser: User?
        
        let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "Email = %@ && Password = %@", email, password))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    var record: CKRecord = records[0] as! CKRecord
                    
                    if let image: UIImage = self.takeImageFromRecord(record, key: "Photo") {
                        newUser = User(email: record.objectForKey("Email") as! String, name: record.objectForKey("Name") as! String, lastName: record.objectForKey("LastName") as! String, password: record.objectForKey("Password") as! String, photo: image)
                        
                        self.delegate?.userReturned(newUser)
                    }
                    
                    else {
                        self.delegate?.userError(nil, auxiliar: "Failed to open the user image")
                    }
                    
                    
                    
                }
            }
        }
        
        return newUser
    }
    
}
