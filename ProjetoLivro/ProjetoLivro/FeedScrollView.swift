//
//  FeedScrollView.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 01/06/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit
import CoreLocation

class FeedScrollView: UIScrollView, UIScrollViewDelegate, FeedRequestDelegate {

    var feedCellQuantity: Int?
    var location: CLLocation?
    var feedRequest: FeedRequest?
    var cellArray:[FeedCellView]!
    var feedObjectArray:[FeedObject]!
    var reloadTimer: NSTimer?
    let cellSpacement = 2.0
    
    init(frame: CGRect!, superview:UIView) {
        super.init(frame: frame)
        
        
        reloadTimer = nil
        
        self.frame = frame
        //self.delegate = self
        feedCellQuantity = 10
        
        cellArray = [FeedCellView]()
        feedObjectArray = [FeedObject]()
        
        feedRequest = FeedRequest(interval: 10)
        feedRequest?.delegate = self
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func requestOffers(userLocation: CLLocation!)->Bool {
        
        if feedRequest?.isRequesting == true {
            return true
        }
        
        self.cellArray.removeAll(keepCapacity: true)
        self.feedObjectArray.removeAll(keepCapacity: true)
        
        self.subviews.map({ $0.removeFromSuperview() })
        
        location = userLocation
        
        if location != nil {
            feedRequest?.receiveFeedLocations(location!)
            return true
        }
        
        else {
            return false
        }
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView) {

    }
    
    func feedInformationError() {
        
    }
    
    func feedInformationCompeted(informations:[FeedObject]) {
        
        var cellFrame = CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: self.superview!.frame.size.height / CGFloat(5.0))
        
        self.contentSize = CGSize(width: self.frame.size.width, height: (cellFrame.size.height + CGFloat(cellSpacement)) * CGFloat(informations.count))
        
        for var cellIndex = 0; cellIndex < informations.count; cellIndex++ {
            
            
            cellFrame.origin.y = (cellFrame.size.height + CGFloat(cellSpacement)) * CGFloat(cellIndex)
            
            var newCell = FeedCellView(frame: cellFrame)
            var buttonUser = UIButton(frame: cellFrame)
            
            buttonUser.addTarget(self, action: Selector("showUserContact:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            buttonUser.tag = cellIndex
            buttonUser.backgroundColor = UIColor.clearColor()
            buttonUser.titleLabel?.text = ""
            self.addSubview(newCell)
            self.addSubview(buttonUser)
            
            self.cellArray?.append(newCell)
            self.feedObjectArray?.append(informations[cellIndex])
            
            newCell.cellInformation(informations[cellIndex])
            
        }
        
        if reloadTimer == nil {
            reloadTimer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateCells"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(reloadTimer!, forMode: NSRunLoopCommonModes)
        }
        
        feedRequest?.isRequesting = false
        
    }
    
    func showUserContact(sender: UIButton) {
        
        //println(sender.tag)
    
        if cellArray[sender.tag].showingContact == true {
            cellArray[sender.tag].showingContact = false
            cellArray[sender.tag].contactView?.removeFromSuperview()
            
            return
        }
        
        if feedObjectArray[sender.tag].user?.email == nil {
            return
        }
        
        var email = feedObjectArray[sender.tag].user?.email
        var name = feedObjectArray[sender.tag].user?.name
        
        var str:String = "Contato com " + name! + ": " + email!
        
        var view:UIView = UIView(frame: cellArray[sender.tag].frame)
        view.backgroundColor = UIColor.blackColor()
        
        var labelUser = UILabel(frame: view.frame)
        var button = UIButton(frame: view.frame)
        
        button.addTarget(self, action: "removeContactView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.frame.origin.y = 0
        labelUser.frame.origin.y = 0
        button.frame.origin.y = 0
        labelUser.text = str
        labelUser.textColor = UIColor.whiteColor()
        labelUser.textAlignment = NSTextAlignment.Center
        labelUser.font = UIFont(name: "Avenir", size: 15.0)
        labelUser.backgroundColor = UIColor.clearColor()
        
        view.addSubview(labelUser)
        view.addSubview(button)
        cellArray[sender.tag].contactView = view
        cellArray[sender.tag].addSubview(view)
        cellArray[sender.tag].showingContact = true
        
    }
    
    func removeContactView(sender: UIView) {
        sender.removeFromSuperview()
    }
    
    func updateCells() {
        
        for var x = 0; x < self.cellArray?.count; x++ {
            
            let feed = self.feedObjectArray[x]
            let cell = self.cellArray[x]
            cell.cellInformation(feed)
            
        }
    }
    
}
