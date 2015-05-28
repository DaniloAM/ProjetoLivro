//
//  User.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 26/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit

protocol LoginDelegate {
    func loginSuccessful(user:User!)
    func loginFailed(error:NSError!,auxiliar:String!)
}

protocol CreateDelegate {
    func createSuccessful(user:User!)
    func createFailed(error:NSError!, auxiliar:String!)
}

class User: NSObject {
    
    // user properties
    var email:String!
    var name:String!
    var lastName:String!
    var password:String!
    var photo:UIImage!
    var userID:String?

    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
    }
    
    convenience init(email:String!, name:String!, lastName:String!,password:String!,photo:UIImage!,userID:String?) {
        self.init()
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
    
    // database variables
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    var loginDelegate: LoginDelegate?
    var registerDelegate: CreateDelegate?
    
    // saves user in database
    func create(){
        
        let newUser = CKRecord(recordType: "User")
        
        self.userID = newUser.recordID.recordName
        newUser.setValue(self.name, forKey: "Name")
        newUser.setValue(self.lastName, forKey: "LastName")
        newUser.setValue(self.email, forKey: "Email")
        newUser.setValue(self.password, forKey: "Password")
        setUserPhoto(newUser, image: self.photo, key: "Photo")
        
        publicData.saveRecord(newUser, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
            //Error in recording
            dispatch_async(dispatch_get_main_queue()) {
                self.registerDelegate?.createFailed(error,auxiliar: nil)
            }
        }
        else {
            //Registration successful
            dispatch_async(dispatch_get_main_queue()) {
                self.registerDelegate?.createSuccessful(self)
            }
        }
        })
        
    }
    
    private func setUserPhoto(newUser:CKRecord,image:UIImage, key:String) ->Bool {
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let writePath = dirPath.stringByAppendingPathComponent("ImageUser.png")
                    UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
                    
                    var File : CKAsset?  = CKAsset(fileURL: NSURL(fileURLWithPath: writePath))
                    newUser.setValue(File, forKey: key)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
}
