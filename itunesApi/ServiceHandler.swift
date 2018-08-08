//
//  ServiceHandler.swift
//  itunesApi
//
//  Created by Manish on 7/19/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceHandler {
    static var dataSorceArray: [Track] = []
      typealias JSONDictionary = [String: Any]
    
    typealias QueryService = ([Track]?) -> ()
    
    static func getTracks(urlString: String, completion: @escaping QueryService) {
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
            
        let dataTask = session.dataTask(with: url) { (data, response, error) in

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    createTracks(data: json!)
                    completion(dataSorceArray)
                    self.dataSorceArray.removeAll()
                }
                catch {
                    print(error)
                }
            }
            
        }
        dataTask.resume()
    }
    
    static func createTracks(data: [String:Any]) {
        let trackDetails = data["results"] as? [[String:Any]]
        for details in trackDetails! {
            if let trackName = details["trackName"] as? String,
                let artistName = details["artistName"] as? String,
                let primaryGenreName = details["primaryGenreName"] as? String,
                let previewUrlString = details["previewUrl"] as? String,
                let previewUrl = URL(string: previewUrlString),
                let artworkUrl100String = details["artworkUrl100"] as? String,
                let artworkUrl100 = URL(string: artworkUrl100String),
                let trackTimeMillis = details["trackTimeMillis"] as? Int
                {
                    let convertedTime = trackDuration(milliseconds: trackTimeMillis)
                    let dataDetail = Track(artworkUrl100: artworkUrl100, trackName: trackName, artistName: artistName, primaryGenreName: primaryGenreName, trackTimeMillis: convertedTime, previewUrl: previewUrl, isDownloaded: false)
                    dataSorceArray.append(dataDetail)
            }
         }
     
    }
    
    static func trackDuration(milliseconds:Int) ->String{
        let seconds = milliseconds / 1000;
        let minutes = String(seconds / 60)
         let second = String( seconds % 60)
        let trackTime = minutes + ":" + second
        return trackTime
    }
}
