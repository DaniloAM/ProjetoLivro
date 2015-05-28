//
//  LoginViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CloudLoginDelegate {

    var cloudAccess: CloudAccess!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudAccess = CloudAccess()
        cloudAccess.loginDelegate = self
        
        var paddingView = UIView(frame: CGRectMake (0, 0, 15, self.emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        
        paddingView = UIView(frame: CGRectMake (0, 0, 15, self.passwordTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
    }

    @IBAction func logIn() {
        cloudAccess.searchForUser(emailTextField.text, password: passwordTextField.text)
    }
    
    func loginSuccessful(user:User!) {
        println("login!")
        
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationController") as! UIViewController
        self.showViewController(secondViewController, sender: true)
    }
    
    func loginFailed(error:NSError!,auxiliar:String!) {
        println(error)
        println(auxiliar)
    }

}
