//
//  SentMemesCollectionViewController.swift
//  Image Picker2
//
//  Created by Quynh Tran on 02/12/2015.
//  Copyright © 2015 Quynh. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController : UICollectionViewController {
    
    var allSentMemes = [MemeObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allSentMemes = appDelegate.allSentMemes
        
        self.collectionView!.reloadData()
        
        self.tabBarController?.tabBar.hidden = false

    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allSentMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.allSentMemes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = self.allSentMemes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }

    
    

}