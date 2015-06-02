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
    
    init(frame: CGRect!, userLocation: CLLocation!, superview:UIView) {
        super.init(frame: frame)
        
        
        reloadTimer = nil
        
        //superview.addSubview(self)
        
        self.frame = frame
        //self.delegate = self
        feedCellQuantity = 10
        location = userLocation
        
        cellArray = [FeedCellView]()
        feedObjectArray = [FeedObject]()
        
        feedRequest = FeedRequest(interval: 10)
        feedRequest?.delegate = self
        
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        
        if location != nil {
            feedRequest?.receiveFeedLocations(location!)
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func scrollViewDidScroll(scrollView:UIScrollView) {
//        if self.contentOffset.y > (self.contentSize.height + self.frame.size.height) {
//            
//            if feedRequest?.isRequesting == false {
//                
//                feedCellQuantity = feedCellQuantity! + 10
//                feedRequest?.receiveFeedLocations(location!)
//            }
//        }
    }
    
    func feedInformationError() {
        
    }
    
    func feedInformationCompeted(informations:[FeedObject]) {
        if informations.count != feedCellQuantity {
            println("oops")
            println(informations.count)
        }
        
        var cellFrame = CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: self.superview!.frame.size.height / CGFloat(5.0))
        
        self.contentSize = CGSize(width: self.frame.size.width, height: (cellFrame.size.height + CGFloat(cellSpacement)) * CGFloat(informations.count))
        
        
        for var cellIndex = feedCellQuantity! - 10; cellIndex < feedCellQuantity; cellIndex++ {
            
            cellFrame.origin.y = (cellFrame.size.height + CGFloat(cellSpacement)) * CGFloat(cellIndex)
            
            var newCell = FeedCellView(frame: cellFrame)
            self.addSubview(newCell)
            
            self.cellArray?.append(newCell)
            self.feedObjectArray?.append(informations[cellIndex])
            
            newCell.cellInformation(informations[cellIndex])
            
        }
        
        if reloadTimer == nil {
            reloadTimer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateCells"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(reloadTimer!, forMode: NSRunLoopCommonModes)
        }
        
    }
    
    func updateCells() {
        
        for var x = 0; x < self.cellArray?.count; x++ {
            
            let feed = self.feedObjectArray[x]
            let cell = self.cellArray[x]
            cell.cellInformation(feed)
            
        }
    }
    
}
