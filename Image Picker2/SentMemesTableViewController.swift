//
//  SentMemesTableViewController.swift
//  Image Picker2
//
//  Created by Quynh Tran on 22/11/2015.
//  Copyright © 2015 Quynh. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var allSentMemes = [MemeObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allSentMemes = appDelegate.allSentMemes
        tableView.reloadData()
        
        tabBarController?.tabBar.hidden = false
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let n = self.allSentMemes.count
        print("Cell count: \(n)")
        return n
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesCell")!
        let meme = self.allSentMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = self.allSentMemes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
}