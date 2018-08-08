		//
//  PresentViewController.swift
//  itunesApi
//
//  Created by Manish on 7/23/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PresentViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet weak var previousSong: UIButton!
    @IBOutlet weak var playAndPausebutton: UIButton!
    @IBOutlet weak var trackArtist: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var startTrackTimer: UILabel!
    @IBOutlet weak var stopTrackTimer: UILabel!
    @IBOutlet weak var randomPlayButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    //MARK:- variables
    var trackStartTime = 0
    var trackStopTime = 30
    var playBackSong = 0
    var randomPlay = 0
    var number : Int?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
            updateUI()
        musicSlider.maximumValue = 30
    _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
        
        
    }
    
//    //MARK:- viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
       handlePlayPauseButton()
    }
    
    //MARK:- Action methods

    @IBAction func musicSlider(_ sender: UISlider) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(sender.value)
        audioPlayer.prepareToPlay()
        handlePlayPauseButton()
        audioPlayer.play()
        handlePlayPauseButton()
    }
    
    @IBAction func sliderButtonTapped(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    @IBAction func previousSongButton(_ sender: Any) {
        if thisSong != 0{
            audioPlayer.stop()

      playThis(thisOne: dataSource[thisSong-1])
        thisSong = thisSong-1
            updateUI()
            
        }
    }
    
    @IBAction func playAndPauseButton(_ sender: UIButton) {
        if audioPlayer.isPlaying
        {
            playAndPausebutton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            audioPlayer.pause()
            
        }
        else{
            playAndPausebutton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            audioPlayer.play()
        }
    
    }
    
    @IBAction func nextSongButton(_ sender: Any) {
        audioPlayer.stop()

        playThis(thisOne: dataSource[thisSong+1])
        thisSong = thisSong+1
        updateUI()
      
    }


    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // For Repeating song
    
    @IBAction func repeateButtonTapped(_ sender: Any) {
        print("repeat")
        playBackSong = playBackSong + 1
        randomPlayButton.setTitle("", for: .normal)
          repeatButton.setTitle("R", for: .normal)
        if playBackSong == 2 {
            repeatButton.setTitle("", for: .normal)
            playBackSong = 0

        }
    }
    
    @IBAction func randomPlaySong(_ sender: Any) {
        print("Play randomly")
        randomPlay = randomPlay + 1
        repeatButton.setTitle("", for: .normal)
       randomPlayButton.setTitle("S", for: .normal)
        playBackSong = 0
        if randomPlay == 2 {
            randomPlayButton.setTitle("", for: .normal)
            randomPlay = 0
        }
    }
    
    //MARK:- Custom Methods
    
     func updateUI() {
  // handlePlayPauseButton()
            trackName.text = dataSource[thisSong].trackName
            trackImage.image = singleton.shared.convertImage(imageURL: dataSource[thisSong].artworkUrl100!)
        trackArtist.text = dataSource[thisSong].artistName
    }
    
    func playThis(thisOne: Track){
        do{
        updateUI()
        let previewUrl = thisOne.previewUrl
        let audioData = try Data(contentsOf: previewUrl!)
        try  audioPlayer = AVAudioPlayer(data: audioData)
        audioPlayer.play()
            handlePlayPauseButton()
        }
        catch{
            print("error")
        }
}
    
    @objc func updateAudioProgressView()
    {
        musicSlider.value = Float(audioPlayer.currentTime)
        let timeInsecond = musicSlider.value
        let seconds = addValue(timeInSecond: timeInsecond)
        if   Int(seconds) <= 30{
          
            startTrackTimer.text = String(seconds)
            trackStopTime = 30 - seconds
            stopTrackTimer.text = String(trackStopTime)
            if timeInsecond > 29.7 {
                startTrackTimer.text = "30"
                stopTrackTimer.text = "0"
                playAndPausebutton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
                if playBackSong == 1{
                    print("Repeating song...")
                    playThis(thisOne: dataSource[thisSong])
                }
                    
                else
                {
                    print("Repeating off")
                }
                
                if randomPlay == 1{
                    number = Int(arc4random_uniform(UInt32(dataSource.count)))
                    thisSong = number!
                    print("Random Playing Started...")
                    playThis(thisOne: dataSource[number!])
                }
                else
                {
                    print("Random Playing Off")
                }
            
            }
           
//            if musicSlider.maximumValue == Float (seconds) {
//             
//            }
        }
      
       
    }
    
    func addValue(timeInSecond : Float) -> Int
    {
        let value = timeInSecond + 0.1
        return Int(value)
    }
    
    func handlePlayPauseButton()
    {
        if audioPlayer.isPlaying
        {
            playAndPausebutton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        else{
            playAndPausebutton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
}
