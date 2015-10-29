//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Hyun on 2015. 10. 4..
//  Copyright (c) 2015년 wook2. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGuideLabel()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false;
        recordingInProgress.text = "Recording"
        stopButton.hidden = false;
        recordButton.enabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath, terminator: "")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings:[:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        audioRecorder.delegate = self;
        
    }
    
    // this func is inherited from UIViewController. It gets called just before a segue way is about to be performed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "stopRecording") {
            // To get a handle on a second view controller in our app
            let playSoundVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag) {
            // Task1.  Initialize a recordedAudio variable through initializer
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true;
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
        recordButton.enabled = true;
        // Task4. Shows this message after switching to RecordSoundingViewController
        showGuideLabel()
    }
    
    func showGuideLabel() {
        recordingInProgress.hidden = false;
        recordingInProgress.text = "tap to record";
    }
}

