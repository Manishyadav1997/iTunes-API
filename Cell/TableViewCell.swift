//
//  TableViewCell.swift
//  itunesApi
//
//  Created by Manish on 7/19/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TableViewCellDelegate {
    func pauseTapped(_ cell: TableViewCell)
    func resumeTapped(_ cell: TableViewCell)
    func cancelTapped(_ cell: TableViewCell)
    func downloadTapped(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {

    
    //MARK:- IBOutlets
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadResumePauseButton: UIButton!
    @IBOutlet weak var downloadCancelButton: UIButton!
    
    //MARK:- Variable
    var delegate: TableViewCellDelegate?

    //MARK:- Download Action Methods
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        downloadButton.isHidden = true
        downloadCancelButton.isHidden = false
        downloadResumePauseButton.isHidden = false
       delegate?.downloadTapped(self)
       }
    
      @IBAction func downloadResumePauseButtontapped(_ sender: Any) {
        if(downloadResumePauseButton.titleLabel?.text == "Pause") {
            downloadResumePauseButton.setTitle("Resume", for: .normal)
            delegate?.pauseTapped(self)
        } else {
            downloadResumePauseButton.setTitle("Pause", for: .normal)
            delegate?.resumeTapped(self)
        }
    
    }
    
    @IBAction func downlaodCancelButtonTapped(_ sender: Any) {
        downloadButton.isHidden = false
        downloadResumePauseButton.isHidden = true
        downloadCancelButton.isHidden = true
      delegate?.cancelTapped(self)
    }
    
    
    
    //MARK:- Custom Methods
    
    func configure(detail: Track) {
        self.trackName.text = detail.trackName
        self.artistName.text = detail.artistName
        self.genre.text = detail.primaryGenreName
        self.trackDuration.text = detail.trackTimeMillis
        if let url = detail.artworkUrl100 {
            songImage.af_setImage(withURL: url)
        
        }
        
        if detail.isDownloaded {
            downloadButton.isHidden = true
            downloadCancelButton.isHidden = true
            downloadResumePauseButton.isHidden = true
        }
        else {
            downloadButton.isHidden = false
        }
    }
    
//    static func downloadFinished()
//    {
//        downloadButton.isHidden = true
//        downloadResumePauseButton.isHidden = true
//        downloadCancelButton.isHidden = true
//    }
    
}
