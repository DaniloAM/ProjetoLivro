//
//  LoginViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserLoginDelegate, UITextFieldDelegate {

    var user: User!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        setTextFieldPadding(emailTextField)
        setTextFieldPadding(passwordTextField)
    }

    @IBAction func logIn() {
        textResign()
        
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        var newUser = User(email: emailTextField.text, password: passwordTextField.text)
        newUser.loginDelegate = self
        newUser.autenticate()
    }
    
    // Sava user information in user default
    
    private func setUserDefalts(user:User!){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(user.name, forKey: "UserName")
        defaults.setObject(user.userID, forKey: "UserID")
    }
    
    // Alert functions
    
    func loginSuccessful(user:User!) {
        waitingView.hidden = true
        waitingIndicator.stopAnimating()
        
        setUserDefalts(user)
        
        // Goes to initial screen
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationController") as! UIViewController
        self.showViewController(secondViewController, sender: true)
    }
    
    func loginFailed(error:NSError!,auxiliar:String!) {
        var refreshAlert = UIAlertController(title: "Atenção!", message: auxiliar, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.waitingView.hidden = true
            self.waitingIndicator.stopAnimating()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        // TODO: REMOVE LATER
        println(error)
    }
    
    // close keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    private func textResign(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // Add style to textfield
    
    private func setTextFieldPadding(textfield: UITextField){
        var paddingView = UIView(frame: CGRectMake (0, 0, 15, textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextFieldViewMode.Always
    }

}
