//
//  SignUpViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class SignUpViewController: MainViewController, UserCreateDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

        setTextFieldPadding([nameField, lastNameField, emailField, passwordField, passwordConfirmationField, securityQuestion, securityAnswer])
    }
    
    // FIRST STEP validates properties
    
    @IBAction func setUserProperties(sender: UIButton) {
        newUser = User(email: emailField.text, name: nameField.text, lastName: lastNameField.text, password: passwordField.text, passwordConfirmation: passwordConfirmationField.text, photo: imageField.image, userID: nil)
        newUser.createDelegate = self
        newUser.hasValidProperties()
        
        waitingView.hidden = false
        waitingIndicator.startAnimating()
    }
    
    func validationSuccessful(){
        waitingView.hidden = true
        waitingIndicator.stopAnimating()
        
        securityView.hidden = false
    }
    
    func validationFailed(error:String) {
        
        showAlert("Atenção!", message: error)
        
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
    }
    
    // SECOND STEP validates security and saves user
    
    @IBAction func back(sender: UIButton) {
        securityView.hidden = true
    }
    
    @IBAction func createUser(sender: UIButton) {
        textResign()
        
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        newUser.securityQuestion = securityQuestion.text
        newUser.securityAnswer = securityAnswer.text
        
        newUser.create()
    }
    
    func createFailed(error:NSError!, auxiliar:String!) {
        
        showAlert("Atenção!", message: auxiliar)
        
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        // TODO: REMOVE LATER
        println(error)
    }
    
    func createSuccessful() {
        
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        showAlert("Cadastro concluido!", message: "Seus dados foram salvos com sucesso! Agora voce ja pode se logar no Trocalê.", redirectTo: "LoginViewController")
    }
    
    // PHOTO FUNCTIONS
    
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
    
    // TEXT FUNCTIONS
    
    private func textResign(){
        nameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        passwordConfirmationField.resignFirstResponder()
        securityAnswer.resignFirstResponder()
        securityQuestion.resignFirstResponder() 
    }
}
