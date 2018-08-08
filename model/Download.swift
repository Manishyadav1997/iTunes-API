//
//  Download.swift
//  itunesApi
//
//  Created by Manish on 7/27/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import Foundation

class Download {
    
    var track: Track
    init(track: Track) {
        self.track = track
    }
    
    // Download service sets these values:
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var downloaded = false
    var resumeData: Data?
    // Download delegate sets this value:
   // var progress: Float = 0
    
}
