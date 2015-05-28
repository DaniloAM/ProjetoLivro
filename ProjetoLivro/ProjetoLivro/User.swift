//
//  User.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 26/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CloudKit

protocol UserLoginDelegate {
    func loginSuccessful(user:User!)
    func loginFailed(error:NSError!,auxiliar:String!)
}

protocol UserCreateDelegate {
    func createSuccessful(user:User!)
    func createFailed(error:NSError!, auxiliar:String!)
    func validationFailed(error:String)
}

class User: NSObject {
    
    // user properties
    var email:String!
    var name:String!
    var lastName:String!
    var password:String!
    var passwordConfirmation:String!
    var photo:UIImage!
    var userID:String?

    override init() {
        container = CKContainer.defaultContainer()
        publicData = container.publicCloudDatabase
        privateData = container.privateCloudDatabase
    }
    
    convenience init(email:String!, name:String!, lastName:String!, password:String!, passwordConfirmation:String!, photo:UIImage!, userID:String?) {
        self.init()
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
        self.photo = photo
        self.userID = userID
    }
    
    convenience init(email:String!, name:String!, lastName:String!, password:String!, photo:UIImage!, userID:String?) {
        self.init()
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.photo = photo
        self.userID = userID
    }
    
    func isValid() ->Bool {
        
        var nilValidationResult = nilValidation()
        if (nilValidationResult != ""){
            self.createDelegate?.validationFailed(nilValidationResult)
            return false
        }
        
        if (!emailValidation()){
            self.createDelegate?.validationFailed("Erro: email incorreto")
            return false
        }
        
        if (!passwordValidation()){
            self.createDelegate?.validationFailed("Erro: senha e confirmação estão diferentes")
            return false
        }
        
        return false
    }
    
    // database variables
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    var loginDelegate: UserLoginDelegate?
    var createDelegate: UserCreateDelegate?
    
    // saves user in database
    func create(){
        
        if (self.isValid()){
        
            let newUser = CKRecord(recordType: "User")
            
            self.userID = newUser.recordID.recordName
            newUser.setValue(self.name, forKey: "Name")
            newUser.setValue(self.lastName, forKey: "LastName")
            newUser.setValue(self.email, forKey: "Email")
            newUser.setValue(self.password, forKey: "Password")
            setUserPhoto(newUser, image: self.photo, key: "Photo")
            
            publicData.saveRecord(newUser, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
                //Error in recording
                self.createDelegate?.createFailed(error,auxiliar: nil)
            }
            else {
                //Registration successful
                self.createDelegate?.createSuccessful(self)
            }
            })
            
        }else{
            println("Foi!")
        }
        
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
    
    // user validations
    
    private func nilValidation() -> String{
        if isEmpty(self.name){
            return "Erro: nome não pode ser nulo"
        }else if isEmpty(self.lastName){
            return "Erro: sobrenome não pode ser nulo"
        }else if isEmpty(self.email){
            return "Erro: email não pode ser nulo"
        }else if isEmpty(self.password){
            return "Erro: senha não pode ser nulo"
        }else if isEmpty(self.passwordConfirmation){
            return "Erro: confirmação de senha não pode ser nulo"
        }else if self.photo == nil{
            return "Erro: foto não pode ser nulo"
        }else{
            return ""
        }
    }
    
    private func emailValidation() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(self.email)
    }
    
    private func passwordValidation() -> Bool{
        return self.password == self.passwordConfirmation
    }
    
    private func isEmpty(val: String) -> Bool{
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed = val.stringByTrimmingCharactersInSet(whitespace)
        return count(trimmed) == 0
    }
}
