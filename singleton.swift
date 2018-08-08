//
//  singleton.swift
//  itunesApi
//
//  Created by Manish on 7/24/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//
import UIKit
import Foundation

class singleton {
   static var shared = singleton()
    
    private init() {}
    
    var image : UIImage?
    func convertImage(imageURL: URL) -> UIImage
    {
        do {
            let data = try Data(contentsOf: imageURL)
            image = UIImage(data: data)
        }
        catch {
            print(error)
        }
        return image!
    }
}
