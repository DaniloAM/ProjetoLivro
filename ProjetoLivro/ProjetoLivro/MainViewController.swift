//
//  MainViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/1/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showAlert(title:String!, message:String!) {
        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func showAlert(title:String!, message:String!, redirectTo:String!) {
        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier(redirectTo) as! UIViewController
            self.showViewController(secondViewController, sender: true)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // text field funcs
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func setTextFieldPadding(fields: [UITextField]){
        for field in fields{
            var paddingView = UIView(frame: CGRectMake (0, 0, 15, field.frame.height))
            field.leftView = paddingView
            field.leftViewMode = UITextFieldViewMode.Always
        }
    }

}
