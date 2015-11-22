//
//  SentMemesTableViewController.swift
//  Image Picker2
//
//  Created by Quynh Tran on 22/11/2015.
//  Copyright © 2015 Quynh. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource {
    
    var allSentMemes: [MemeObject] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).allSentMemes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allSentMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesCell")!
        let meme = self.allSentMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
}