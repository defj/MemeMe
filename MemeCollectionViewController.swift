//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Joshua Gan on 11/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    var memes: [Meme]!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup nav bar
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "startOver")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "startOver")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCCell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // St the image
        cell.memeImageView.image = meme.memedImage
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    func startOver() {
        if let navigationController = self.navigationController? {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
}
