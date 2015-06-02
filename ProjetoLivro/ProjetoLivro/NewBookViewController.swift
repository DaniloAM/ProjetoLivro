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
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
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
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        startWaiting()
        
        data = apiBook.searchForBooks(searchBar.text)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        stoptWaiting()
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! ApiBookTableViewCell
        
        cell.bookTitle.text = (data[indexPath.row]).name
        cell.bookInformation.text = (data[indexPath.row]).author
        cell.bookImage.image = (data[indexPath.row]).coverPhoto
        cell.bookPublish.text = (data[indexPath.row]).publish
        
        println((data[indexPath.row]).apiLink)
        
        return cell;
    }
    
    // WAITING
    
    private func startWaiting(){
        self.waitingView.hidden = false
        self.waitingIndicator.startAnimating()
    }
    
    private func stoptWaiting(){
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
    }
}
