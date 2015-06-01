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
    let cellSpacement = 2.0
    
    init(frame: CGRect, userLocation: CLLocation) {
        super.init(frame: frame)
        
        self.frame = frame
        self.delegate = self
        feedCellQuantity = 10
        location = userLocation
        
        feedRequest = FeedRequest(interval: 10)
        feedRequest?.delegate = self
        feedRequest?.receiveFeedLocations(location!)
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func scrollViewDidScroll(scrollView:UIScrollView) {
        if self.contentOffset.y > (self.contentSize.height + self.frame.size.height) {
            
            if feedRequest?.isRequesting == false {
                
                feedCellQuantity = feedCellQuantity! + 10
                feedRequest?.receiveFeedLocations(location!)
            }
        }
    }
    
    func feedInformationError() {
        
    }
    
    func feedInformationCompeted(informations:[FeedObject]) {
        if informations.count != feedCellQuantity {
            println("oops")
        }
    
        
        
        var cellFrame = CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: self.superview!.frame.size.height / CGFloat(5.0))
        
        var userTest = User(email: "", name: "Nome legal", lastName: "", password: "", photo: UIImage(named: "alphaBody.png"), userID: "")
        
        for var cellIndex = feedCellQuantity! - 10; cellIndex < feedCellQuantity; cellIndex++ {
            
            cellFrame.origin.y = (cellFrame.size.height + CGFloat(cellSpacement)) * CGFloat(cellIndex)
            
            var newCell = FeedCellView(frame: cellFrame)
            
            newCell.cellInformation(userTest, locationName: "Santo Amaro", books: ["Harry Potter", "Eragon", "Livro bom", "Livro não tão bom", "Livro para teste", "Mais teste", "Ultimo teste"])
            
            self.addSubview(newCell)
            
        }
        
    }
    
}
