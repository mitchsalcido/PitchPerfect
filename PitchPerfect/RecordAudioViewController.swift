//
//  RecordAudioViewController.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var audioPromptLabel: UILabel!
    @IBOutlet var recordAudioButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    enum RecordAudioState {
        case recording
        case notRecording
        case unknownRecordingCondition
    }
    
    struct AudioRecorderAlerts {
        static let SetSessionCategoryError = "Error Setting Audio Session Category"
        static let CreateAudioRecorderError = "Error Creating Audio Recorder"
        static let AudioSessionSetActiveError = "Error Changing Audio Session State"
        static let FilePathCreationError = "Unable to Create Audio File Path"
        static let AudioAlertHelpfulMessage = "Contact the App Store for Prompt and Courteous Service"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(state: .notRecording)
    }
    
    @IBAction func recordAudioButtonPressed(_ sender: UIButton) {
        configureUI(state: .recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else {
            configureUI(state: .unknownRecordingCondition)
            showAlert(alertTitle: AudioRecorderAlerts.FilePathCreationError)
            return
        }
                
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            do {
                try audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            } catch {
                configureUI(state: .unknownRecordingCondition)
                showAlert(alertTitle: AudioRecorderAlerts.CreateAudioRecorderError, message: String(describing: error))
            }
        } catch {
            configureUI(state: .unknownRecordingCondition)
            showAlert(alertTitle: AudioRecorderAlerts.SetSessionCategoryError, message: String(describing: error))
        }
    }

    @IBAction func stopRecordingButtonPressed(_ sender: UIButton) {
        configureUI(state: .notRecording)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            configureUI(state: .unknownRecordingCondition)
            showAlert(alertTitle: AudioRecorderAlerts.AudioSessionSetActiveError, message: String(describing: error))
        }
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
            let viewController = segue.destination as! PlaybackAudioViewController
            let url = sender as! URL
            viewController.audioURL = url
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "PlaybackAudioSegue", sender: recorder.url)
        } else {
            print("didn't record audio successfully")
        }
    }
    
    func showAlert(alertTitle: String, message: String? = nil) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
