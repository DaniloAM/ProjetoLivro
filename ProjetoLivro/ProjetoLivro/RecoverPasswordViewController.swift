//
//  RecoverPasswordViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/27/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: MainViewController, UserRecoverPasswdDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var recoverContView: UIView!
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var securityQuestionLabel: UILabel!
    @IBOutlet weak var securityAnswerField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    var newUser:User!
    
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        securityAnswerField.delegate = self
        passwordConfirmationField.delegate = self
        passwordField.delegate = self

        setTextFieldPadding([emailField, securityAnswerField, passwordField, passwordConfirmationField])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRecoverPasswordInstructions(sender: AnyObject) {
        textResign()
        
        mainView.hidden = true
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        newUser = User.new()
        newUser.email = emailField.text
        newUser.recoverPasswdDelegate = self
        newUser.recoverPassword()
    }
    
    @IBAction func answerQuestion(sender: UIButton) {
        var answer = securityAnswerField.text
        answer = answer.lowercaseString
        answer = answer.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if (answer == self.newUser.securityAnswer){
            questionView.hidden = true
            passwordView.hidden = false
        }else{
            showAlert("Atenção", message: "A resposta de segurança está incorreta")
            
            self.securityAnswerField.text = ""
        }
    }
    
    @IBAction func changePassword(sender: UIButton) {
        recoverContView.hidden = true
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        
        newUser.password = passwordField.text
        newUser.passwordConfirmation = passwordConfirmationField.text
        newUser.changePassword()
    }
    
    // recover delegates
    
    func changeFailed(error:NSError!, auxiliar:String!){
        showAlert("Atenção!", message: auxiliar)
        
        self.recoverContView.hidden = false
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        println(error)
    }
    
    func changeSuccessful(){
        showAlert("Alteração de senha", message: "Sua senha foi alterada com sucesso! Agora voce ja pode se logar no Trocalê")
        
        self.waitingIndicator.stopAnimating()
        
        // Goes to initial screen
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.showViewController(secondViewController, sender: true)
    }
    
    func recoverFailed(error:NSError!, auxiliar:String!){
        showAlert("Atenção!", message: auxiliar)
        
        self.mainView.hidden = false
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        println(error)
    }
    
    func recoverSuccessful(){
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
        
        recoverContView.hidden = false
        questionView.hidden = false
        securityQuestionLabel.text = self.newUser.securityQuestion
    }

    // close keyboard

    private func textResign(){
        emailField.resignFirstResponder()
        passwordConfirmationField.resignFirstResponder()
        passwordField.resignFirstResponder()
        securityAnswerField.resignFirstResponder()
    }

}
