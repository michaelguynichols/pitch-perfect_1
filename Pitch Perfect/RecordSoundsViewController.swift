//
//  RecourdSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Nichols on 6/1/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var alert:UIAlertController!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var tapToRecordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Making required items visible/invisible
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecordLabel.hidden = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        // Making labels, buttons visible, invisible
        recordLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        tapToRecordLabel.hidden = true
        
        // Getting the dirPath
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // Use same file name to overwrite previous data and save space.
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Set up the audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Record audio
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // Task 1 -> calling RecordedAudio initalizer to load filepath and title
            recordedAudio = RecordedAudio(filePath: recorder.url, titleString: recorder.url.lastPathComponent!)
            
            // Stop recording the user's voice
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            alert = UIAlertController(title: "Error", message: "The recording was unsuccessful.", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in})
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Preparing for segue to other scene.
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: AnyObject) {
        // Wrapping up the recording
        recordLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession()
        audioSession.setActive(false, error: nil)
    }
}

