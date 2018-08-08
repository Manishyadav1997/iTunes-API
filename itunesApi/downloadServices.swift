//
//  downloadServices.swift
//  itunesApi
//
//  Created by Manish on 7/27/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import Foundation

class downloadSevices{
    static var activeDownloads: [URL: Download] = [:]
    static var downloadsSession: URLSession!
    
    // MARK: - Download methods called by TableViewCell delegate methods
    
    static func startDownload(_ track: Track) {
        let download = Download(track: track)
        download.task = downloadsSession.downloadTask(with: track.previewUrl!)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.track.previewUrl!] = download
    }
    static func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewUrl!] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    static func cancelDownload(_ track: Track) {
        if let download = activeDownloads[track.previewUrl!] {
            download.task?.cancel()
            activeDownloads[track.previewUrl!] = nil
        }
    }
    
    static func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewUrl!] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.previewUrl!)
        }
        download.task!.resume()
        download.isDownloading = true
    }
    
}
