//
//  BooksViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, BookSearchDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    
    var newBook:Book = Book.new()
    var data:[Book] = []
    
    var book: Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var id = ""
        id = userDefaults.stringForKey("UserID")!
        
        newBook.searchDelegate = self
        dispatch_async(dispatch_get_main_queue()) {
            self.newBook.getUserBooks(id)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! ApiBookTableViewCell
        
        cell.bookTitle.text = (data[indexPath.row]).name
        cell.bookInformation.text = (data[indexPath.row]).author
        
        if ((data[indexPath.row]).coverPhoto != nil){
            cell.bookImage.image = (data[indexPath.row]).coverPhoto
        }
        cell.bookPublish.text = (data[indexPath.row]).publish
        
        println((data[indexPath.row]).apiLink)
        
        return cell;
    }
    
    // DELEGATE FUNCTIONS
    
    func bookFound(books:[Book]){
        data = books
        self.tableView.reloadData()
    }

}
