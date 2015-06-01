//
//  referencia.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class referencia: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        showBookDetails(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func showBookDetails(name: String) {
        
        var url: String
        
        if name.isEmpty {
            return
        }
            
        else {
            
            var nameConvert: String = name.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            url = "https://www.googleapis.com/books/v1/volumes?q=" + nameConvert + "&langRestrict=pt"
        }
        
        var couldFind: Bool = false
        
        
        
        if let linkUrl: NSURL = NSURL(string: url) {
            
            if let data: NSData = NSData(contentsOfURL: linkUrl) {
                
                if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) {
                    
                    if let books: NSArray = json!.objectForKey("items") as? NSArray {
                        
                        if let firstResult: NSDictionary = books.objectAtIndex(0) as? NSDictionary {
                            
                            if let bookInfo: NSDictionary = firstResult.objectForKey("volumeInfo") as? NSDictionary {
                                
                                if let bookName: String = bookInfo.objectForKey("title") as? String {
                                    
                                    nameLabel.text = bookName
                                }
                                
                                if let authorsArray: NSArray = bookInfo.objectForKey("authors") as? NSArray {
                                    
                                    if let author: String = authorsArray.firstObject as? String {
                                        
                                        authorLabel.text = author
                                    }
                                }
                                
                                if let year: String = bookInfo.objectForKey("publishedDate") as? String{
                                    
                                    yearLabel.text = year
                                }
                                
                                if let description: String = bookInfo.objectForKey("description") as? String {
                                    
                                    descriptionTextView.text = description
                                }
                                
                                if let imageLinks: NSDictionary = bookInfo.objectForKey("imageLinks") as? NSDictionary {
                                    
                                    if let urlImage: String = imageLinks.objectForKey("smallThumbnail") as? String {
                                        
                                        if let imageData: NSData = NSData(contentsOfURL: NSURL(string: urlImage)!)  {
                                            
                                            if let image: UIImage = UIImage(data: imageData) {
                                                
                                                imageBook.image = image
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}
