//
//  ProfileViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WARNING: test-only *** WARNING: test-only
        UserData.sharedInstance.user = User(email: "as@as.con", name: "as", lastName: "bs", password: "as", photo: UIImage(named: "alphaBody.png"), userID: "2380E3E2-DB09-4367-B877-62B156B5575F")
        //WARNING: test-only *** WARNING: test-only

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    @IBAction func updateName(sender: AnyObject) {
    }
    @IBAction func updateEmail(sender: AnyObject) {
    }
    @IBAction func updatePassword(sender: AnyObject) {
    }


}
