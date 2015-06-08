//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Michael Nichols on 6/3/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    // Task 1: adding an initializer to class
    init(filePath: NSURL, titleString: String) {
        self.filePathUrl = filePath
        self.title = titleString
    }
    
}