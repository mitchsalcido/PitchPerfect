//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/13/21.
//
/*
About AudioRecorder.swift
 Class to handle audio recording. Handles starting and stopping of recording. Requires valid delegate.
 */

import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    // reference to delegate
    var delegate: AudioRecorderDelegate!
    
    // reference to Audio Recorder
    private var audioRecorder: AVAudioRecorder!
    
    // record audio
    func record() {
        
        // create a file-url to save recorder audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]

        var comps = URLComponents()
        comps.path = pathArray.joined(separator: "/")
        guard let filePath = comps.url else {
            delegate.audioRecorderError(AudioRecorderError.audioFilepathError)
            return
        }
        
        // get session and create audioRecorder. Start recording
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
                delegate.audioRecorderError(AudioRecorderError.audioRecorderError)
            }
        } catch {
            delegate.audioRecorderError(AudioRecorderError.audioSessionError)
        }
    }
    
    // stop recording audio
    func stop() {
        
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            delegate.audioRecorderError(AudioRecorderError.audioSessionError)
        }
    }
    
    // MARK: AVAudioRecorderDelegate function
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // recording ended
        delegate.audioFinishedRecording(url: recorder.url)
    }
}
