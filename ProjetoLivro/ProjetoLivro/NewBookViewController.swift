//
//  NewBookViewController.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 27/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class NewBookViewController: MainViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    
    var apiBook:ApiBook = ApiBook.new()
    var data:[Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // SEARCH BAR
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar, searchText: String) {
        //searchActive = false;
        data = apiBook.searchForBooks(searchText)
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
       // searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //searchActive = false;
        
        data = apiBook.searchForBooks(searchBar.text)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
        
        //data = apiBook.searchForBooks(searchText)
        //self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! UITableViewCell;
        
        cell.textLabel?.text = (data[indexPath.row]).name;
        cell.detailTextLabel?.text = (data[indexPath.row]).author;
        
        return cell;
    }
}
