//
//  ProfileViewController.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 5/26/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class ProfileViewController: MainViewController, UserUpdateDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageStyle()
        
        // saves
        let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // gets
        var getImagePath = paths.stringByAppendingPathComponent("UserPhoto.png")
        if (!fileManager.fileExistsAtPath(getImagePath))
        {
            startWaiting()
        }
        getInformationSuccessful()
        getUserInformation()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logOut(sender: AnyObject) {
        user.logOut()
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.showViewController(secondViewController, sender: false)
    }
    
    private func getUserInformation(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let id = defaults.stringForKey("UserID")
        
        user = User.new()
        user.updateDelegate = self
        user.userID = id;
        user.getSelfInformation()
    }
    
    @IBAction func updateName(sender: UIButton) {
        
    }
    
    @IBAction func updateEmail(sender: UIButton) {
        
    }
    
    @IBAction func updatePassword(sender: UIButton) {
        
    }
    
    // DELEGATE FUNCTIONS
    
    func updateFailed(error:String!){
        showAlert("Atenção", message: error)
        stoptWaiting()
    }
    
    func updateSuccessful(){
        stoptWaiting()
    }
    
    func getInformationSuccessful(){
        stoptWaiting()
        
        
        // saves
        let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // gets
        var getImagePath = paths.stringByAppendingPathComponent("UserPhoto.png")
        if (fileManager.fileExistsAtPath(getImagePath))
        {
            var image: UIImage = UIImage(contentsOfFile: getImagePath)!
            
            imageField.image = nil
            imageField.image = image
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        nameLabel.text = defaults.stringForKey("UserName")
        emailLabel.text = defaults.stringForKey("UserEmail")
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
        imageField.image = nil
        imageField.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    private func setImageStyle(){
        self.imageField.layer.cornerRadius = self.imageField.frame.size.width / 2;
        self.imageField.clipsToBounds = true;
        self.imageField.layer.borderWidth = 6.0
        self.imageField.layer.borderColor = UIColor(red: 206/255.0, green: 196/255.0, blue: 174/255.0, alpha: 1.0).CGColor
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
