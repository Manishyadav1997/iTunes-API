//
//  URLHandler.swift
//  itunesApi
//
//  Created by Manish on 7/19/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

let BASE_URL = "https://itunes.apple.com/search?"

func createStringURL(stringFile: String) -> String {
    
    guard let searchString = stringFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return ""}
    
    let urlString = "term=" + searchString + "&media=music&entity=musicTrack"
    
    return BASE_URL + urlString
}
