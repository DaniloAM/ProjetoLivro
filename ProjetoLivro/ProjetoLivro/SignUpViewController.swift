//
//  SignUpViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UserCreateDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: User!
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var securityQuestion: UITextField!
    @IBOutlet weak var securityAnswer: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var securityView: UIView!
    
    var newUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmationField.delegate = self
        securityQuestion.delegate = self
        securityAnswer.delegate = self
        
        self.imageField.layer.cornerRadius = self.imageField.frame.size.width / 2;
        self.imageField.clipsToBounds = true;

        setTextFieldPadding(nameField)
        setTextFieldPadding(lastNameField)
        setTextFieldPadding(emailField)
        setTextFieldPadding(passwordField)
        setTextFieldPadding(passwordConfirmationField)
        setTextFieldPadding(securityQuestion)
        setTextFieldPadding(securityAnswer)
    }
    
    @IBAction func showSecurity(sender: UIButton) {
        newUser = User(email: emailField.text, name: nameField.text, lastName: lastNameField.text, password: passwordField.text, passwordConfirmation: passwordConfirmationField.text, photo: imageField.image, userID: nil)
        newUser.createDelegate = self
        if (newUser.isValid()){
            securityView.hidden = false
        }
    }
    
    @IBAction func back(sender: UIButton) {
        securityView.hidden = true
    }
    
    @IBAction func signUp(sender: UIButton) {
        textResign()
        
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        newUser.securityQuestion = securityQuestion.text
        newUser.securityAnswer = securityAnswer.text
        newUser.create()
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        sender.setTitle("", forState: UIControlState.Normal)
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageField.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    // Alert functions
    
    func createSuccessful(user: User!) {
        
        var refreshAlert = UIAlertController(title: "Cadastro concluido!", message: "Seus dados foram salvos com sucesso! Agora voce ja pode se logar no app.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.waitingView.hidden = true
            self.waitingIndicator.stopAnimating()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        // Goes to initial screen
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.showViewController(secondViewController, sender: true)
    }
    
    func createFailed(error:NSError!, auxiliar:String!) {
        var refreshAlert = UIAlertController(title: "Atenção!", message: auxiliar, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.waitingView.hidden = true
            self.waitingIndicator.stopAnimating()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        // TODO: REMOVE LATER
        println(error)
    }
    
    func validationFailed(error:String) {
        var refreshAlert = UIAlertController(title: "Atenção!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.waitingView.hidden = true
            self.waitingIndicator.stopAnimating()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
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
        nameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        passwordConfirmationField.resignFirstResponder()
        securityAnswer.resignFirstResponder()
        securityQuestion.resignFirstResponder() 
    }
    
    // Add style to textfield
    
    private func setTextFieldPadding(textfield: UITextField){
        var paddingView = UIView(frame: CGRectMake (0, 0, 15, textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextFieldViewMode.Always
    }

}
