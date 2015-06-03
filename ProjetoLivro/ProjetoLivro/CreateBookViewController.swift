//
//  CreateBookViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/2/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class CreateBookViewController: MainViewController, BookCreateDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var stateDescription: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    var book:Book!
    override func viewDidLoad() {
        super.viewDidLoad()

        setImageStyle()
        setBomState(self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // STATE
    
    @IBAction func setBomState(sender: AnyObject) {
        var description = "BOM\r\n\r\nLivro em bom estado, sem dobras ou partes rasgadas e conteúdo intácto."
        stateDescription.text = description
        book.stateID = "BOM"
    }
    
    @IBAction func setOkState(sender: UIButton) {
        var description = "OK\r\n\r\nLivro com poucas dobras e amassados mas com seu conteúdo intácto."
        stateDescription.text = description
        book.stateID = "OK"
    }
    
    @IBAction func setRuimState(sender: UIButton) {
        var description = "RUIM\r\n\r\nLivro em péssimo estado, bastante dobras e amassados, mas com seu conteúdo intácto."
        stateDescription.text = description
        book.stateID = "RUIM"
    }
    
    // BOOK DELEGATES
    
    func createSuccessful(){
        showAlert("Livro criado!", message: "Parabéns, seu livro foi  cadastrado com sucesso!")
    }
    
    func createFailed(error:String!){
        showAlert("Atenção!", message: error)
    }
    
    func validateSuccessful(){
        book.create()
    }
    
    func validateFailed(error:String!){
        showAlert("Atenção!", message: error)
    }

    // CREATE
    
    @IBAction func createBook(sender: UIBarButtonItem) {
        book.createDelegate = self
        
        var id = ""
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("UserID") != nil) {
            id = userDefaults.stringForKey("UserID")!
        }
        
        book.userPhoto = bookImage.image
        book.userID = id
        // if valid it calls validateSuccessful
        book.isValid()
    }
    
    // PHOTO
    
    @IBAction func takePhoto(sender: UIButton) {
        sender.setTitle("", forState: UIControlState.Normal)
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        bookImage.image = nil
        bookImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    private func setImageStyle(){
        self.bookImage.layer.borderWidth = 6.0
        self.bookImage.layer.borderColor = UIColor(red: 206/255.0, green: 196/255.0, blue: 174/255.0, alpha: 1.0).CGColor
    }
    
    // WAITING
    
    private func startWaiting(){
        self.waitingView.hidden = false
        self.waitingIndicator.startAnimating()
    }
    
    private func stoptWaiting(){
        self.waitingView.hidden = true
        self.waitingIndicator.stopAnimating()
    }

}
