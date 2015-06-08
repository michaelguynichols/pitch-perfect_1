//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Nichols on 6/2/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Declaring global variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing the audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Initializing the audioEngine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio(rate: Float) {
        // A function to play audio with a given rate.
        audioStopperHelper()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func audioStopperHelper() {
        // A helper function to stop the audioPlayer and audioEngine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func slowPlay(sender: UIButton) {
        // Play audio slowly
        playAudio(0.5)
    }

    @IBAction func fastPlay(sender: UIButton) {
        // Play audio fast
        playAudio(1.5)
    }
   
    @IBAction func stopAudio(sender: UIButton) {
        // Stopping all audio that may be in progress.
        audioStopperHelper()
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        // Play audio with a high pitch to simulate chipmunk voices
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        // Play audio with a low pitch to simulate Darth Vader's voice
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        // A function to create a pitch effect
        audioStopperHelper()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
}
