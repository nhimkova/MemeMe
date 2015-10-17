//
//  MemeObject.swift
//  Image Picker2
//
//  Created by Quynh Tran on 17/10/2015.
//  Copyright (c) 2015 Quynh. All rights reserved.
//

import UIKit

class MemeObject: NSObject {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!

    init(top: String, bottom: String, image: UIImage, meme: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.originalImage = image
        self.memedImage = meme
    }
}
