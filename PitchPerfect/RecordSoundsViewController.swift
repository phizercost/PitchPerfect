//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Phizer Cost on 4/19/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlets
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!

    
    // MARK: Actions
    @IBAction func startRecording(_ sender: Any) {
        configureUIRecording(state: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUIRecording(state: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   
    // MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIRecording(state: false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print ("Recording not successfull")
        }
        
    }
    func configureUIRecording (state: Bool) {
        if state {
            startButton.isEnabled = false
            stopButton.isEnabled = true
            recordingLabel.text = "Recording in Progress"
        } else {
            startButton.isEnabled = true
            stopButton.isEnabled = false
            recordingLabel.text = "Start Recording"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudiuURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudiuURL
        }
    }
    


}

