//
//  ViewController.swift
//  ProjetoLivro
//
//  Created by Danilo Mative on 25/05/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

protocol CloudAccessDelegate {
    func userRegistered(success:Bool)
    func userReturned(user:User!)
    func userError(error:NSError!, auxiliar:String!)
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

