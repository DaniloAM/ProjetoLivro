//
//  ApiBook.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class ApiBook: NSObject {
   
    
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
                                        
                                    }
                                }
                                
                                books.append(book)
                            }
                            
                        }
                        
                    }
                }
            }

        }
        
        return books
    }
    
    private func isEmpty(val: String) -> Bool{
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed = val.stringByTrimmingCharactersInSet(whitespace)
        return count(trimmed) == 0
    }
}
