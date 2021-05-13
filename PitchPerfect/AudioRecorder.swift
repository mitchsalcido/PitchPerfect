//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/13/21.
//

import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    var delegate: AudioRecorderDelegate!
    private var audioRecorder: AVAudioRecorder!
    
    func record() {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]

        var comps = URLComponents()
        comps.path = pathArray.joined(separator: "/")
        guard let filePath = comps.url else {
            delegate.audioRecorderError(AudioRecorderError.audioFilepathError)
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
                delegate.audioRecorderError(AudioRecorderError.audioRecorderError)
            }
        } catch {
            delegate.audioRecorderError(AudioRecorderError.audioSessionError)
        }
    }
    
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate.audioFinishedRecording(url: recorder.url)
    }
}
