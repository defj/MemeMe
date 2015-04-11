//
//  Meme.swift
//  Image Picker
//
//  Created by Joshua Gan on 6/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage!
    var memedImage: UIImage!
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }

    
}
