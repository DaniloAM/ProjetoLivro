//
//  CloudAccess.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 27/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit

protocol CloudLoginDelegate {
    func loginSuccessful(user:User!)
    func loginFailed(error:NSError!,auxiliar:String!)
}

protocol CloudRegisterDelegate {
    func userRegistered(user:User!)
    func registerError(error:NSError!, auxiliar:String!)
}

class CloudAccess: NSObject {
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    var loginDelegate: CloudLoginDelegate?
    var registerDelegate: CloudRegisterDelegate?
    
    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
    }
    
    func registerUser(user:User) {

        let record = CKRecord(recordType: "User")
        
        user.userID = record.recordID.recordName
        record.setValue(user.name, forKey: "Name")
        record.setValue(user.lastName, forKey: "LastName")
        record.setValue(user.email, forKey: "Email")
        record.setValue(user.password, forKey: "Password")
        addImageToRecord(record, image: user.photo, key: "Photo")
        
        publicData.saveRecord(record, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
            //Error in recording
            dispatch_async(dispatch_get_main_queue()) {
                self.registerDelegate?.registerError(error,auxiliar: nil)
            }
        }
            
        else {
            //Registration successful
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.registerDelegate?.userRegistered(user)
            }
            }
        })
        
        
        
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
                        newUser = User(email: record.objectForKey("Email") as! String, name: record.objectForKey("Name") as! String, lastName: record.objectForKey("LastName") as! String, password: record.objectForKey("Password") as! String, photo: image, userID: record.recordID.recordName)
                        
                        //Found user
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loginDelegate?.loginSuccessful(newUser)
                        }
                    }
                    
                    else {
                        //Image error
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loginDelegate?.loginFailed(nil, auxiliar: "Failed to open the user image")
                        }
                    }
                    
                    
                    
                }
                
                else {
                    //No errors, but no user found with this email and password
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginDelegate?.loginFailed(error, auxiliar: "Email and/or password not found")
                    }
                }
            }
            
            else {
                //Some error occurred
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginDelegate?.loginFailed(error, auxiliar: "Error")
                }
            }
        }
        
        return newUser
    }
    
}
