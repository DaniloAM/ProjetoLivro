//
//  RecoverPasswordViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/27/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func sendRecoverPasswordInstructions(sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
