
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
    func createSuccessful()
    func createFailed(error:NSError!, auxiliar:String!)
    func validationFailed(error:String)
    func validationSuccessful()
}

protocol UserRecoverPasswdDelegate {
    func recoverFailed(error:NSError!, auxiliar:String!)
    func recoverSuccessful()
    func changeFailed(error:NSError!, auxiliar:String!)
    func changeSuccessful()
}

protocol UserUpdateDelegate {
    func updateFailed(error:String!)
    func updateSuccessful()
    func getInformationSuccessful()
}

class User: NSObject {
    
    var email:String!
    var name:String!
    var lastName:String!
    var password:String!
    var passwordConfirmation:String!
    var photo:UIImage!
    var userID:String?
    var securityQuestion:String!
    var securityAnswer:String!

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
        self.photo = photo
        self.userID = userID
    }
    
    convenience init(email:String!, password:String!) {
        self.init()
        self.email = email
        self.password = password
    }
    
    // DATABASE VARIABLES
    
    var container: CKContainer
    var publicData: CKDatabase
    var privateData: CKDatabase
    var loginDelegate: UserLoginDelegate?
    var createDelegate: UserCreateDelegate?
    var recoverPasswdDelegate: UserRecoverPasswdDelegate?
    var updateDelegate: UserUpdateDelegate?
    
    // CREATES USER
    
    func create(){
        
        var result = hasValidSecurity()
        if (result == ""){
        
            let newUser = CKRecord(recordType: "User")
            
            self.userID = newUser.recordID.recordName
            newUser.setValue(self.name, forKey: "Name")
            newUser.setValue(self.lastName, forKey: "LastName")
            newUser.setValue(self.email, forKey: "Email")
            newUser.setValue(self.password, forKey: "Password")
            newUser.setValue(self.securityQuestion, forKey: "SecurityQuestion")
            // trim the extra spaces off the beginning and end
            self.securityAnswer = self.securityAnswer.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            newUser.setValue(self.securityAnswer.lowercaseString, forKey: "SecurityAnswer")
            setUserPhoto(newUser, image: self.photo, key: "Photo")
            
            publicData.saveRecord(newUser, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
                //Error in recording
                self.createDelegate?.createFailed(error, auxiliar: "Houve um problema ao salvar suas informações no banco de dados, por favor tente novamente")
            }
            else {
                //Registration successful
                self.createDelegate?.createSuccessful()
            }
            })
            
        }
        else {
            self.createDelegate?.createFailed(nil ,auxiliar: result)
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
    
    // UPDATE USER
    
    func getSelfInformation(){
        
        let wellKnownID: CKRecordID! = CKRecordID(recordName: self.userID)
        
        publicData.fetchRecordWithID(wellKnownID, completionHandler: { record, error in
            if let fetchError = error {
                // Some error occurred
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateDelegate?.updateFailed(error.description)
                }
            } else {
                // set self information
                self.name = record.objectForKey("Name") as! String
                self.lastName = record.objectForKey("LastName") as! String
                self.email = record.objectForKey("Email") as! String
                self.photo = self.getUserPhoto(record, key: "Photo")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateDelegate?.getInformationSuccessful()
                }
            }
        })
        
    }
    
    // RECOVER PASSWORD
    
    func recoverPassword() {
        
        let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "Email = %@", self.email))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    var record: CKRecord = records[0] as! CKRecord
                    
                    self.userID = record.recordID.recordName
                    self.securityQuestion = record.objectForKey("SecurityQuestion") as! String
                    self.securityAnswer = record.objectForKey("SecurityAnswer") as! String
                    
                    //Found user
                    dispatch_async(dispatch_get_main_queue()) {
                        self.recoverPasswdDelegate?.recoverSuccessful()
                    }
                }
                else {
                    //No errors, but no user found
                    dispatch_async(dispatch_get_main_queue()) {
                        self.recoverPasswdDelegate?.recoverFailed(error, auxiliar: "Nenhum usuário encontrado com este email! Tente novamente")
                    }
                }
            }
            else {
                //Some error occurred
                dispatch_async(dispatch_get_main_queue()) {
                    self.recoverPasswdDelegate?.recoverFailed(error, auxiliar: "Erro")
                }
            }
        }
    }
    
    func changePassword(){
        
        var result = hasValidPassword()
        if (result == ""){
            
            let wellKnownID: CKRecordID! = CKRecordID(recordName: self.userID)
        
            publicData.fetchRecordWithID(wellKnownID, completionHandler: { record, error in
                if let fetchError = error {
                    //Some error occurred
                    dispatch_async(dispatch_get_main_queue()) {
                        self.recoverPasswdDelegate?.changeFailed(error, auxiliar: "Erro")
                    }
                } else {
                    // Modify the record
                    record.setObject(self.password, forKey: "Password")
                    
                    self.publicData.saveRecord(record, completionHandler: { record, error in
                        if let saveError = error {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.recoverPasswdDelegate?.changeFailed(error, auxiliar: error.description)
                            }
                        } else {
                            // Saved record
                            dispatch_async(dispatch_get_main_queue()) {
                                self.recoverPasswdDelegate?.changeSuccessful()
                            }
                        }
                    })
                } 
            })
            
        } else {
            self.recoverPasswdDelegate?.changeFailed(nil, auxiliar: result)
        }
    }
    
    // LOGIN USER
    
    func autenticate() {
        
        var newUser: User?
        
        let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "Email = %@ && Password = %@", self.email, self.password))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    var record: CKRecord = records[0] as! CKRecord
                    
                    newUser = User.new()
                    newUser?.name = record.objectForKey("Name") as! String
                    newUser?.userID = record.recordID.recordName

                    //Found user
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginDelegate?.loginSuccessful(newUser)
                    }

                }
                    
                else {
                    //No errors, but no user found with this email and password
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginDelegate?.loginFailed(error, auxiliar: "Email e/ou senha não encontrados")
                    }
                }
            }
                
            else {
                //Some error occurred
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginDelegate?.loginFailed(error, auxiliar: error.description)
                }
            }
        }
    }
    
    private func getUserPhoto(record:CKRecord, key:String) ->UIImage? {
        
        if let asset:CKAsset = record.objectForKey(key) as? CKAsset {
            if let data: NSData = NSData(contentsOfURL: asset.fileURL) {
                return UIImage(data: data)
            }
        }
        
        return nil
    }
    
    // USER DEFAULTS
    
    func setUserDefalts(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(self.name, forKey: "UserName")
        defaults.setObject(self.userID, forKey: "UserID")
    }
    
    // USER VALIDATIONS
    
    func hasValidProperties() {
        
        var result = ""
        
        result = hasEmptyProperties()
        if (result != ""){
            self.createDelegate?.validationFailed(result)
        }
        
        result = hasValidPassword()
        if (result != ""){
            self.createDelegate?.validationFailed(result)
        }
        
        result = hasValidEmail()
        if (result != ""){
            self.createDelegate?.validationFailed(result)
        }
        
        isEmailUsed()
    }
    
    private func hasValidSecurity() -> String {
        
        if (isEmpty(securityQuestion)){
            return "Por favor, preencha a pergunta de segurança"
        }
        
        if (isEmpty(securityAnswer)){
            return "Por favor, preencha a resposta de segurança"
        }
        
        return ""
    }
    
    private func hasEmptyProperties() -> String{
        if isEmpty(self.name){
            return "Por favor, preencha o nome"
        }else if isEmpty(self.lastName){
            return "Por favor, preencha o sobrenome"
        }else if isEmpty(self.email){
            return "Por favor, preencha o email"
        }else if self.photo == nil{
            return "Por favor, escolha uma foto de perfil"
        }else{
            return ""
        }
    }
    
    private func hasValidEmail() -> String  {
        if (!isEmpty(self.email)){
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            if (NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(self.email)){
                return ""
            }else{
                return "O email informado não é valido"
            }
        }else{
            return "Por favor, preencha o email"
        }
    }
    
    func hasValidPassword() -> String {
        
        if (isEmpty(self.password)){
            return "Por favor, preencha a senha"
        }else if (isEmpty(self.passwordConfirmation)){
            return "Por favor, preencha a confirmação de senha"
        }else if (self.password != self.passwordConfirmation){
            return "A senha e confirmação estão diferentes"
        }
        
        return ""
    }
    
    private func isEmpty(val: String) -> Bool{
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed = val.stringByTrimmingCharactersInSet(whitespace)
        return count(trimmed) == 0
    }
    
    private func isEmailUsed() {
        let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "Email = %@", self.email))
        
        publicData.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if records.count > 0 {
                    // User found
                    dispatch_async(dispatch_get_main_queue()) {
                        self.createDelegate?.validationFailed("Este email já está sendo usado por outro usuário")
                    }
                }
                else {
                    // No user fooun
                    dispatch_async(dispatch_get_main_queue()) {
                        self.createDelegate?.validationSuccessful()
                    }
                }
            }
            else {
                //Some error occurred
                dispatch_async(dispatch_get_main_queue()) {
                    self.createDelegate?.validationFailed(error.description)
                    println(error)
                }
            }
        }
    }
}
