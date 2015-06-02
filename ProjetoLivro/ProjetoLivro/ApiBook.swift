//
//  ApiBook.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

protocol BookInformationDelegate {
    func foundBookInformation()
    func bookInformationError(error:String!)
}

class ApiBook: NSObject {
   
    var informationDelegate:BookInformationDelegate?
    
    func searchForBooks(search:String) -> [Book] {
        
        var url: String
        var books:[Book]
        books = []
        
        
        if (!isEmpty(search)) {
            var nameConvert: String = search.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            url = "https://www.googleapis.com/books/v1/volumes?q=" + nameConvert + "&langRestrict=pt"
            
            var couldFind: Bool = false
            
            if let linkUrl: NSURL = NSURL(string: url) {
                if let data: NSData = NSData(contentsOfURL: linkUrl) {
                    if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) {
                        if let searchBooks: NSArray = json!.objectForKey("items") as? NSArray {
                            
                            for searchBook in searchBooks{
                                
                                var book = Book.new()
                                
                                if let firstResult: NSDictionary = searchBook as? NSDictionary{
                                    if let bookInfo: NSDictionary = firstResult.objectForKey("volumeInfo") as? NSDictionary {
                                        
                                        if let bookName: String = bookInfo.objectForKey("title") as? String {
                                            book.name = bookName
                                        }
                                        
                                        if let authorsArray: NSArray = bookInfo.objectForKey("authors") as? NSArray {
                                            if let author: String = authorsArray.firstObject as? String {
                                                book.author = author
                                            }
                                        }
                                        
                                        if let year: String = bookInfo.objectForKey("publishedDate") as? String{
                                            book.publish = year
                                        }
                                        
                                        if let link: String = bookInfo.objectForKey("selfLink") as? String{
                                            book.apiLink = link
                                        }
                                        
                                        if let imageLinks: NSDictionary = bookInfo.objectForKey("imageLinks") as? NSDictionary {
                                            if let urlImage: String = imageLinks.objectForKey("smallThumbnail") as? String {
                                                if let imageData: NSData = NSData(contentsOfURL: NSURL(string: urlImage)!)  {
                                                    if let image: UIImage = UIImage(data: imageData) {
                                                        
                                                        book.coverPhoto = image
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                }// for end
                                
                                books.append(book)
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
        
        return books
    }
    
    func bookInformationsFromAPIUrl(book:Book, feed:FeedObject) {
        
        if book.apiLink == nil {
            
            self.informationDelegate?.bookInformationError("url is nil")
            return
        }
        
        let url = book.apiLink
        var couldFind: Bool = false
        
        if let linkUrl: NSURL = NSURL(string: url) {
            
            if let data: NSData = NSData(contentsOfURL: linkUrl) {
                
                if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) {
                    
                    if let bookInfo: NSDictionary = json!.objectForKey("volumeInfo") as? NSDictionary {
                        
                        if let bookName: String = bookInfo.objectForKey("title") as? String {
                            book.name = bookName
                        }
                        
                        if let imageLinks: NSDictionary = bookInfo.objectForKey("imageLinks") as? NSDictionary {
                            if let urlImage: String = imageLinks.objectForKey("smallThumbnail") as? String {
                                if let imageData: NSData = NSData(contentsOfURL: NSURL(string: urlImage)!)  {
                                    if let image: UIImage = UIImage(data: imageData) {
                                        
                                        book.coverPhoto = image
                                        
                                    }
                                }
                            }
                        }
                        
                        feed.bookArray.append(book)
                        
                        self.informationDelegate?.foundBookInformation()
                        
                        return
                    }
                }
            }
        }
        
        self.informationDelegate?.bookInformationError("Failed to retrieve some informations from json")
        
    }
    
    
    private func isEmpty(val: String) -> Bool{
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed = val.stringByTrimmingCharactersInSet(whitespace)
        return count(trimmed) == 0
    }
}
