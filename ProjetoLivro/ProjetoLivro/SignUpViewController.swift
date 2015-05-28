//
//  SignUpViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UserCreateDelegate, UITextFieldDelegate {

    var user: User!
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmationField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        var newUser = User(email: emailField.text, name: nameField.text, lastName: lastNameField.text, password: passwordField.text, passwordConfirmation: passwordConfirmationField.text, photo: imageField.image, userID: nil)
        newUser.createDelegate = self
        newUser.create()
    }
    
    func createSuccessful(user: User!) {
        println("registered!")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func createFailed(error:NSError!, auxiliar:String!) {
        println(error)
        println(auxiliar)
    }
    
    func validationFailed(error:String) {
        println(error)
    }

}
