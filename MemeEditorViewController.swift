//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Joshua Gan on 11/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Setup Meme font
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    // Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var topNavBar: UIToolbar!
    
    // Text Field Delegate objects
    let topTextDelegate = MemeTextFieldDelegate()
    let bottomTextDelegate = MemeTextFieldDelegate()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Text fields
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.delegate = topTextDelegate
        self.topText.textAlignment = .Center
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.delegate = bottomTextDelegate
        self.bottomText.textAlignment = .Center
        
        // Setup NavBar
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "startOver")
//        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareMeme")
//        
//        
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "collection"), style: .Plain, target: self, action: "startOver")
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // UIImagePickerController protocol functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // Image from Album
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    // Image from Camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        println("in keyboard Show")
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("in keyboard Hide")
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    

    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // Generate Memed image
        let generatedImage = generateMemedImage()
        
        // Present the Activity View Controller
        let activityViewController = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = saveMemeAfterSharing
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
 
    @IBAction func cancelEditor(sender: UIBarButtonItem) {
        // Dismiss View Controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func startOver() {
        if let navigationController = self.navigationController? {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        //self.navigationController?.navigationBar.hidden = true
        self.topNavBar.hidden = true
        self.bottomNavBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        //self.navigationController?.navigationBar.hidden = false
        self.topNavBar.hidden = false
        self.bottomNavBar.hidden = false
        
        return memedImage
    }
    
    
    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveMeme() {
        // Generate Memed image
        let generatedImage = generateMemedImage()
        var meme = Meme(topText: self.topText.text, bottomText: self.bottomText.text, image: self.memeImage.image!, memedImage: generatedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.append(meme)
    }
    
 
}