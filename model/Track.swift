//
//  Track.swift
//  itunesApi
//
//  Created by Manish on 7/19/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

struct Track {
    
    var artworkUrl100:URL?
    var trackName:String
    var artistName:String
    var primaryGenreName:String
    var trackTimeMillis:String
    var previewUrl: URL?
    var isDownloaded = false
}

