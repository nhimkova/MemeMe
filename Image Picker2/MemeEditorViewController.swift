//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Quynh Tran on 03/10/2015.
//  Copyright (c) 2015 Quynh. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var initialImage: UIImage!
    var initialTopText: String!
    var initialBottomText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(topTextField, defaultText: "TOP", initialText: initialTopText)
        prepareTextField(bottomTextField, defaultText: "BOTTOM", initialText: initialBottomText)
        
        if ( initialImage != nil )
        {
            imagePickerView?.image = initialImage
        }
        
        toolbar.hidden = false
        
    }
    
    func prepareTextField(textField: UITextField, defaultText: String, initialText: String!) {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        
        if (initialText == nil)
        {
            textField.text = defaultText
        }
        else
        {
            textField.text = initialText
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        
        //Check if camera available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Disable share button if no image
        if let _ = imagePickerView.image {
            shareButton.enabled = true
        }
        else { shareButton.enabled = false }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    /////////////////////Pick image methods
    @IBAction func pickAnImageFromGallery(sender: AnyObject) {
        pickAnImageFrom("PhotoLibrary")
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFrom("Camera")
    }
    
    func pickAnImageFrom(sourceType: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (sourceType == "Camera") {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    ////////////////////Keyboard methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Dismisses the keyboard when you press return (the bottom right key)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Detects when a user touches the screen and tells the keyboard to disappear when that happens
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
        textField.text = ""
        }
    }
    
    /////////////////////////// Meme object methods
    
    @IBAction func shareButton(sender: AnyObject) {
        let memedIm = [generateMemedImage()]
        let controller = UIActivityViewController(activityItems: memedIm, applicationActivities: nil)
        
        controller.completionWithItemsHandler = myHandler
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func myHandler(activityType:String?, completed: Bool,
        returnedItems: [AnyObject]?, error: NSError?) {
            if (completed)
            {
                save()
                print("Activity: \(activityType) Success: \(completed) Items: \(returnedItems) Error: \(error)")
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func save() {
        let memedIm = generateMemedImage()
        let meme = MemeObject(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePickerView.image!, meme: memedIm)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.allSentMemes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        
        return memedImage
    }
    
    
    @IBAction func cancelMemeEditor(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

