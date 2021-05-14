//
//  AudioRecorderViewControll.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//
/*
About AudioRecorderViewController.swift
 UIViewController subclass to handle starting and stopping audio recording.
 */

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate, AudioRecorderDelegate {

    // UI elements
    @IBOutlet private var audioPromptLabel: UILabel!
    @IBOutlet private var recordAudioButton: UIButton!
    @IBOutlet private var stopRecordingButton: UIButton!
    
    // reference to AudioRecorder
    private var audioRecorder: AudioRecorder!
    
    // enum of recording state. Used to steer UI enable/disable states
    enum RecordAudioState {
        case recording
        case notRecording
        case unknownRecordingCondition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navbar title and UI config
        title = "PitchPerfect - Record"
        configureUI(state: .notRecording)
    }
    
    // record audio button pressed
    @IBAction func recordAudioButtonPressed(_ sender: UIButton) {
        
        // configure UI. Create audioRecorder and begin recording
        configureUI(state: .recording)
        audioRecorder = AudioRecorder()
        audioRecorder.delegate = self
        audioRecorder.record()
    }

    // stop recording button pressed
    @IBAction func stopRecordingButtonPressed(_ sender: UIButton) {
        
        // configure UI and stop recording
        configureUI(state: .notRecording)
        audioRecorder.stop()
    }
    
    // helper function to set the view UI objects
    func configureUI(state: RecordAudioState) {
        switch state {
        case .recording:
            audioPromptLabel.text = "...recording audio"
            recordAudioButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        case .notRecording:
            audioPromptLabel.text = "Tap to record audio"
            recordAudioButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        case .unknownRecordingCondition:
            audioPromptLabel.text = "unknown recording condition problem"
            recordAudioButton.isEnabled = false
            stopRecordingButton.isEnabled = false
        }
    }
    
    // prep segeu destination (AudioPlaybackViewController) for playback by passing audio url
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaybackAudioSegue" {
            let viewController = segue.destination as! AudioPlaybackViewController
            let url = sender as! URL
            viewController.audioURL = url
        }
    }
    
    // MARK: AudioRecorderDelegate functions
    func audioFinishedRecording(url: URL) {
        
        // finished recording. Segue to playback
        performSegue(withIdentifier: "PlaybackAudioSegue", sender: url)
    }
    
    func audioRecorderError(_ error: AudioRecorderError) {
        
        // recording error. Place UI in known state and show alert
        configureUI(state: .unknownRecordingCondition)
        showAlert(error)
    }
}
