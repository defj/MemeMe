//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Joshua Gan on 11/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes: [Meme]!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup nav bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "presentMemeEditor")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve stored memes
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
        // Present the Meme Editor if we have no sent Memes
        if self.memes?.count == 0 {
            presentMemeEditor()
        }

        // Reload Data
        self.collectionView?.reloadData()
    }
    
   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Populate collection view
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCCell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // St the image
        cell.memeImageView.image = meme.memedImage
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // Show details of selected meme
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func presentMemeEditor() {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var memeEditor = storyboard.instantiateViewControllerWithIdentifier("memeEditor") as MemeEditorViewController
        self.presentViewController(memeEditor, animated: true, completion: nil)
    }
}
