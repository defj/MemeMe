//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Joshua Gan on 8/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeDetail: UIImageView!
    
    
    var meme: Meme!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeDetail!.image = meme.memedImage

    }

}

