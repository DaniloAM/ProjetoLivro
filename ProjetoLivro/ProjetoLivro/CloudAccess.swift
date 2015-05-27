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
            
            publicData.saveRecord(record, completionHandler: { (record, error) -> Void in if error != nil {
                    println(error)
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
                    let writePath = dirPath.stringByAppendingPathComponent("Image2.png")
                    UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
                    
                    var File : CKAsset?  = CKAsset(fileURL: NSURL(fileURLWithPath: writePath))
                    record.setValue(File, forKey: key)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
}
