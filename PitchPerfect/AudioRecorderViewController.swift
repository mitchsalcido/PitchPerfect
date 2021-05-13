//
//  AudioRecorderViewControll.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate, AudioRecorderDelegate {

    @IBOutlet var audioPromptLabel: UILabel!
    @IBOutlet var recordAudioButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    var audioRecorder: AudioRecorder!
    
    enum RecordAudioState {
        case recording
        case notRecording
        case unknownRecordingCondition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PitchPerfect - Record"
        configureUI(state: .notRecording)
    }
    
    @IBAction func recordAudioButtonPressed(_ sender: UIButton) {
        configureUI(state: .recording)
        audioRecorder = AudioRecorder()
        audioRecorder.delegate = self
        audioRecorder.record()
    }

    @IBAction func stopRecordingButtonPressed(_ sender: UIButton) {
        configureUI(state: .notRecording)
        audioRecorder.stop()
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaybackAudioSegue" {
            let viewController = segue.destination as! AudioPlaybackViewController
            let url = sender as! URL
            viewController.audioURL = url
        }
    }
    
    
    func audioFinishedRecording(url: URL) {
        performSegue(withIdentifier: "PlaybackAudioSegue", sender: url)
    }
    
    func audioRecorderError(_ error: AudioRecorderError) {
        configureUI(state: .unknownRecordingCondition)
        showAlert(error)
    }
}
