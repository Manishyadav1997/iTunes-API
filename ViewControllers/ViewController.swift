//
//  ViewController.swift
//  itunesApi
//
//  Created by Manish on 7/19/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import ReactiveCocoa
import AVFoundation

var dataSource :[Track] = []
var audioPlayer = AVAudioPlayer()
var thisSong = 0

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var play_PauseButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var genre: UILabel!
 
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    
    //MARK:- Variables
   // var cellcount = 0
    var index = 0
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.reloadData()
        tableView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        bottomView.isHidden = true
        tableView.reloadData()
        tableView.rowHeight = 94
        searchBarUpdate()
        downloadSevices.downloadsSession = downloadsSession
        
    }
    
    //MARK:- ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {

        if dataSource.count > 0
        {
         if   audioPlayer.isPlaying {
            play_PauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)

        }
        else{
            play_PauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
            trackName.text = dataSource[thisSong].trackName
            trackImage.image = singleton.shared.convertImage(imageURL: dataSource[thisSong].artworkUrl100!)
            genre.text = dataSource[thisSong].primaryGenreName
        }

    }

    //MARK:- UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let down = TableViewCell()
//        down.resetDownload()

        return dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        let detail = dataSource[indexPath.row]
        cell.delegate = self
        cell.configure(detail: detail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     tableView.reloadData()
        do {
            print("hi")
         let path = dataSource[indexPath.row]
            thisSong = indexPath.row
        let previewUrl = path.previewUrl
        let audioData = try Data(contentsOf: previewUrl!)
        try  audioPlayer = AVAudioPlayer(data: audioData)
        audioPlayer.play()
        bottomView.isHidden = false
        trackName.text = path.trackName
        genre.text = path.primaryGenreName
            trackImage.image = singleton.shared.convertImage(imageURL: path.artworkUrl100!)
    }
        catch {
            print(error)
        }
        
    }
    
    //MARK:- IBActions
    
    @IBAction func play_PauseButtonTapped(_ sender: Any) {
        if audioPlayer.isPlaying
        {
            play_PauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            audioPlayer.pause()
        }
        else{
            play_PauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            audioPlayer.play()
            
        }
        }
    

    
    @IBAction func PresentViewButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PresentViewController.self)) as! PresentViewController
        self.present(vc,animated: true,completion: nil)
    }
    
    
    //Handling the user String
    func searchBarUpdate() {
        searchBar.reactive.searchButtonClicked.observeValues {
            [unowned self] in
            dataSource.removeAll()
            if var searchKeyword = self.searchBar.text {
                searchKeyword = searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
                if searchKeyword.count > 0 {
                    ServiceHandler.getTracks(urlString: createStringURL(stringFile: searchKeyword), completion: { (track) in
                        if let data = track {
                            DispatchQueue.main.async {
                              dataSource = data
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
            
        }
    }
    
    
}

extension ViewController:TableViewCellDelegate
{
    
    func downloadTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = dataSource[indexPath.row]
            downloadSevices.startDownload(track)
            index = indexPath.row
        }
    }
    
    func pauseTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell)
        {
        let track = dataSource[indexPath.row]
            downloadSevices.pauseDownload(track)
           
            
        }
        
        }
    
    func resumeTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = dataSource[indexPath.row]
            downloadSevices.resumeDownload(track)
            
        }
    }
    
    func cancelTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = dataSource[indexPath.row]
            downloadSevices.cancelDownload(track)
            
        }
    }
    
    
    // Update track cell's buttons
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("Finished downloading to \(location).")
        
        dataSource[index].isDownloaded = true
        
        DispatchQueue.main.async {
            self.reload(self.index)
        }
    }
}
