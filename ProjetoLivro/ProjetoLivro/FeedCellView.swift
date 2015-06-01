//
//  FeedCellView.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 30/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class FeedCellView: UIView {

    let userWidthFactor = 0.3
    let offerWidthFactor = 0.7
    let bookWidthFactor = 0.8
    let bookHeightFactor = 0.5
    
    let bookSpacementFactor = 0.15
    
    
    var userView: UIView!
    var userNameText: UILabel!
    var userImage: UIImageView!
    var userLocationText: UILabel!
    
    var offerScrollView: UIScrollView!
    
    var picture: UIImageView!
    var userName: String!
    var books = [UIImageView]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.frame = frame
        
        println(self.frame.size.width)
        
        var frameExample = self.frame
        frameExample.origin.x = 0.0
        frameExample.origin.y = 0.0
        
        var userFrame = frameExample
        userFrame.size.width *= CGFloat(userWidthFactor)
        userView = UIView(frame: userFrame)
        userView.backgroundColor = UIColor(red: 234.0 / 255.0, green: 223.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
        userView.layer.shadowOffset = CGSizeMake(0, 7);
        userView.layer.shadowRadius = 5;
        userView.layer.shadowOpacity = 0.3;
        
        
        
        var userImageFrame = userFrame
        userImageFrame.size.height = userFrame.size.height / 2.0
        userImageFrame.size.width = userImageFrame.size.height
        userImage = UIImageView(frame:userImageFrame)
        userImage.center = userView.center
        userImage.frame.origin.y -= self.frame.size.height * 0.1
        userImage.layer.cornerRadius = userImage.frame.size.height / 2.0
        userImage.backgroundColor = UIColor.blackColor()
        
        userView.addSubview(userImage)
        
        var userNameFrame = frameExample
        userNameFrame.size.height *= (self.frame.size.height * 0.001)
        userNameFrame.size.width = userView.frame.size.width
        userNameFrame.origin.y = userImage.frame.origin.y + userImageFrame.size.height + (self.frame.size.height * 0.05)
        userNameText = UILabel(frame:userNameFrame)
        userNameText.font = UIFont(name: "Avenir", size: 10.0)
        userNameText.textAlignment = NSTextAlignment.Center
        
        userView.addSubview(userNameText)
        
        var userLocationFrame = userNameFrame
        userLocationFrame.origin.y += (self.frame.size.height * 0.1)
        userLocationText =  UILabel(frame:userLocationFrame)
        userLocationText.font = UIFont(name: "Avenir", size: 10.0)
        userLocationText.textAlignment = NSTextAlignment.Center
        
        userView.addSubview(userLocationText)

        var offerFrame = frameExample
        offerFrame.size.width -= userView.frame.size.width
        offerFrame.origin.x += userView.frame.size.width
        offerScrollView = UIScrollView(frame: offerFrame)
        offerScrollView.frame = offerFrame
        offerScrollView.backgroundColor = UIColor(red: 234.0 / 255.0, green: 223.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
        offerScrollView.showsHorizontalScrollIndicator = false
        
        self.addSubview(offerScrollView)
        self.addSubview(userView)
        
        
        println(userView.frame.size.width)
        println(offerScrollView.frame.origin.x)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cellInformation(user:User!,locationName:String!, books:[String]!) {
        userNameText.text = user.name
        userImage.image = user.photo
        userLocationText.text = locationName
        
        var frameExample = self.frame
        frameExample.origin.x = 0.0
        frameExample.origin.y = 0.0
        
        var bookHeight = Double(self.frame.size.height) * bookHeightFactor
        var bookWidth = bookHeight * bookWidthFactor
        var bookSpacement = bookWidth * bookSpacementFactor
        
        var scrollContentSize = CGSize(width: Double(books.count) * (bookWidth + bookSpacement), height: Double(offerScrollView.frame.size.height))
        
        scrollContentSize.width += CGFloat(bookSpacement)
        offerScrollView.contentSize = scrollContentSize
        
        var bookY = Double(self.frame.size.height / 2.0) - Double(bookHeight / 2.0)
        
        var bookFrame = CGRect(x: bookSpacement, y:bookY , width: bookWidth, height: bookHeight)
        var labelFrame = bookFrame
        labelFrame.size.height = self.frame.size.height * (self.frame.size.height * 0.001)
        labelFrame.origin.y += bookFrame.height + (self.frame.size.height * 0.05)
        
        for var x = 0; x < books.count; x++ {
            
            var newBook = UIImageView(frame: bookFrame)
            //***** ADD IMAGE FROM BOOK OBJECT ******
            newBook.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            //***** ADD IMAGE FROM BOOK OBJECT ******
            
            var bookName = UILabel(frame: labelFrame)
            //***** ADD NAME FROM BOOK OBJECT ******
            bookName.text = books[x]
            //***** ADD NAME FROM BOOK OBJECT ******
            bookName.font = UIFont(name: "Avenir", size: 8.0)
            bookName.textAlignment = NSTextAlignment.Center
            
            labelFrame.origin.x += CGFloat(bookSpacement + bookWidth)
            bookFrame.origin.x += CGFloat(bookSpacement + bookWidth)
            
            offerScrollView.addSubview(bookName)
            offerScrollView.addSubview(newBook)
        }
    }
}
