//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Hyun on 2015. 10. 12..
//  Copyright (c) 2015년 wook2. All rights reserved.
//

import Foundation


class RecordedAudio : NSObject {
    
    var filePathUrl: NSURL!
    var title : String! 
    
    // Add a initializer which takes two parameters : filepath and title
    init (filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}