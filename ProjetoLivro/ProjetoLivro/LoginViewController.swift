//
//  LoginViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class LoginViewController: MainViewController, UserLoginDelegate {

    var user: User!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        setTextFieldPadding([emailTextField, passwordTextField])
    }

    @IBAction func logIn() {
        textResign()
        
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        var newUser = User(email: emailTextField.text, password: passwordTextField.text)
        newUser.loginDelegate = self
        newUser.autenticate()
    }
    
    // Alert functions
    
    func loginSuccessful(user:User!) {
        waitingView.hidden = true
        waitingIndicator.stopAnimating()
        
        user.setUserDefalts()
        
        // Goes to initial screen
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationController") as! UIViewController
        self.showViewController(secondViewController, sender: true)
    }
    
    func loginFailed(error:NSError!,auxiliar:String!) {
        showAlert("Atenção", message: auxiliar)
        
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        // TODO: REMOVE LATER
        println(error)
    }
    
    // close keyboard
    
    private func textResign(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}
