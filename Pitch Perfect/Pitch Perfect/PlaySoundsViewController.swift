//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Hyun on 2015. 10. 9..
//  Copyright (c) 2015 wook2. All rights reserved.
//

import UIKit
import AVFoundation 

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!             // declare AVAudioEngine Object
    
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()       // initialize an AVAudioEngine variable
        
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        audioPlayer.rate = 0.5
        playNormalAudio()
    }

    @IBAction func playFastAudio(sender: AnyObject) {
        audioPlayer.rate = 1.5
        playNormalAudio()
    }
    
    func playNormalAudio() {
        stopAndResetAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    func stopAndResetAudio() {
        audioEngine.reset()            // for stopping all audio effects
        audioPlayer.stop()

    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAudio()
        audioPlayer.currentTime = 0.0
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioEngine.stop()
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()          // declare and initialize an AVAudioPlayerNode variable
        audioEngine.attachNode(audioPlayerNode)            // attach AVAudioPlayerNode to AVAudioEngine
        
        let changePitchEffect = AVAudioUnitTimePitch()     // declare and initialize an AVAudioUnitTimePitch variable
        changePitchEffect.pitch = pitch                    // set the value of the pitch attribute as a given value
        audioEngine.attachNode(changePitchEffect)          // attach AVAudioUnitTimePitch to AVAudioEngine
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)    // connect AVAudioPlayerNode to AVAudioUnitTimePitch
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil) // connect AVAudioUnitTimePitch to Output
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
  
}
