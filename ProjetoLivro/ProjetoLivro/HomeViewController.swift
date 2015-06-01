//
//  HomeViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var profileButton: UIBarButtonItem!

    let cellSpacement = 2.0
    
    var feedScrollView:UIScrollView!
    var numberOfFeeds: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfFeeds = 10
        
        var barSize = 65.0
        var cellSize = self.view.frame.size.height / CGFloat(5.0)
        
        var frame = CGRect(x: 0, y: CGFloat(barSize), width: self.view.frame.size.width, height: CGFloat(self.view.frame.size.height - CGFloat(barSize)))
        
        feedScrollView = UIScrollView(frame: frame)
        feedScrollView.showsVerticalScrollIndicator = false
        feedScrollView.backgroundColor = UIColor(red: 38 / 255, green: 61 / 255, blue: 79 / 255, alpha: 1.0)
        
        var height = cellSpacement + Double(cellSize)
        height *= Double(numberOfFeeds)
        
        feedScrollView.contentSize = CGSize(width: Double(self.view.frame.size.width), height: height)
        
        self.view.addSubview(feedScrollView)
        
        var cellFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / CGFloat(5.0))
        
        var userTest = User(email: "", name: "Nome legal", lastName: "", password: "", photo: UIImage(named: "alphaBody.png"), userID: "")
        
        for var x = 0; x < numberOfFeeds; x++ {
            var newCell = FeedCellView(frame: cellFrame)
            
            newCell.cellInformation(userTest, locationName: "Santo Amaro", books: ["Harry Potter", "Eragon", "Livro bom", "Livro não tão bom", "Livro para teste", "Mais teste", "Ultimo teste"])


            feedScrollView.addSubview(newCell)
            
            cellFrame.origin.y += cellFrame.size.height + CGFloat(cellSpacement)
            
        }

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "showProfile" {
            if (!checkUserLogged()){
                return false
            }
        }
        
        // by default, transition
        return true
    }
    
    func checkUserLogged() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let id = defaults.stringForKey("UserID")
        
        if (id == ""){
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.showViewController(secondViewController, sender: true)
            return false
        }
        else{
            return true
        }
    }
}

