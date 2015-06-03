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

protocol BookCreateDelegate {
    func createSuccessful()
    func createFailed(error:String!)
    func validateSuccessful()
    func validateFailed(error:String!)
}

class Book: NSObject {
   
    // database properties
    var bookID:String!
    var apiLink:String!
    var stateID:String!
    var userID:String!
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
    var createDelegate: BookCreateDelegate?

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
                   
                        
                        for record in records{
                            var bookRecord = record as! CKRecord
                            var book = Book.new()
                            var apiBook = ApiBook.new()
                            
                            book.bookID = bookRecord.recordID.recordName
                            book.apiLink = bookRecord.valueForKey("APILink") as! String
                            book.stateID = bookRecord.valueForKey("StateID") as! String
                            book.name = bookRecord.valueForKey("Name") as! String
                            book.coverPhoto = self.getBookPhoto(bookRecord, key: "CoverPhoto")
                            
                            //book = apiBook.getAllApiInformation(book)
                            
                            books.append(book)
                        }
                        
                        self.searchDelegate?.bookFound(books)
                    
                }
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
    
    
    
    func create(){
        
        let newBook = CKRecord(recordType: "Book")
        self.bookID = newBook.recordID.recordName
        
        newBook.setValue(self.apiLink, forKey: "APILink")
        newBook.setValue(self.stateID, forKey: "StateID")
        newBook.setValue(self.userID, forKey: "UserID")
        newBook.setValue(self.name, forKey: "Name") // book name
        
        if (!setBookPhoto(newBook, image: self.userPhoto, key: "UserPhoto")){
            self.createDelegate?.createFailed("Houve um erro ao salvar a foto do livro, por faor tente novamente")
            return
        }
        
        if (!setBookPhoto(newBook, image: self.coverPhoto, key: "CoverPhoto")){
            self.createDelegate?.createFailed("Houve um erro ao salvar a foto da capa do livro, por faor tente novamente")
            return
        }
        
        publicData.saveRecord(newBook, completionHandler: { (record, error: NSError!) -> Void in if error != nil {
            //Error in recording
            self.createDelegate?.createFailed("Houve um erro ao salvar os dados do livro no banco de dados, por favor tente novamente")
        }
        else {
            //Registration successful
            self.createDelegate?.createSuccessful()
            }
        })
        
    }
    
    func isValid(){
        if (self.userPhoto == nil){
            self.createDelegate?.validateFailed("Por favor, tire uma foto do livro")
            return
        }
        
        // This will call create method
        self.createDelegate?.validateSuccessful()
    }
    
    private func setBookPhoto(newBook:CKRecord,image:UIImage, key:String) ->Bool {
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let writePath = dirPath.stringByAppendingPathComponent("BookImage.png")
                    UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
                    
                    var File : CKAsset?  = CKAsset(fileURL: NSURL(fileURLWithPath: writePath))
                    newBook.setValue(File, forKey: key)
                    
                    return true
                }
            }
        }
        
        return false
    }
}
