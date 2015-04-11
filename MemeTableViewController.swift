//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Joshua Gan on 11/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource {
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup nav bar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "startOver")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Present the Meme Editor if we have no sent Memes
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var memeEditor = storyboard.instantiateViewControllerWithIdentifier("memeEditor") as MemeEditorViewController
        self.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
