//
//  MemeDetailsViewController.swift
//  Image Picker2
//
//  Created by Quynh Tran on 30/11/2015.
//  Copyright © 2015 Quynh. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController : UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
    
    var meme : MemeObject!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        let memedIm = [meme.memedImage]
        let controller = UIActivityViewController(activityItems: memedIm, applicationActivities: nil)
        
        controller.completionWithItemsHandler = myHandler
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func myHandler(activityType:String?, completed: Bool,
        returnedItems: [AnyObject]?, error: NSError?) {
            if (completed)
            {
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    @IBAction func editButton(sender: AnyObject) {
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        editorController.initialImage = meme.originalImage
        editorController.initialTopText = meme.topText
        editorController.initialBottomText = meme.bottomText
        
        let navController = UINavigationController(rootViewController: editorController)
        
        self.presentViewController(navController, animated:true, completion: nil)
        
        //self.navigationController!.pushViewController(editorController, animated: true)
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
}
