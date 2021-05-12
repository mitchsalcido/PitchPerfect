//
//  PlaybackAudioViewController.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//

import UIKit
import AVFoundation

class PlaybackAudioViewController: UIViewController, AudioPlayerDelegate {
    
    var audioURL: URL!

    @IBOutlet var fastButton: UIButton!
    @IBOutlet var slowButton: UIButton!
    @IBOutlet var highPitchButton: UIButton!
    @IBOutlet var lowPitchButton: UIButton!
    @IBOutlet var echoButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    var audioPlayer: AudioPlayer!
    
    enum AudioPlaybackState {
        case playing
        case notPlaying
        case unknownPlaybackCondition
    }
    
    enum AudioEffect: Int {
        case fast = 0
        case slow
        case highPitch
        case lowPitch
        case echo
        case reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(state: .notPlaying)
        configButtonAlignment()
        
        self.showAlert(AudioPlayerError.audioNodeError)
    }
    
    func audioStartedPlaying() {
        print("audioStartedPlaying")
    }
    func audioFinishedPlaying() {
        print("audioFinishedPlaying")
        configureUI(state: .notPlaying)
    }
    func audioPlayerError(_ error: AudioPlayerError) {
        print("audioPlayerError")
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        configureUI(state: .playing)

        guard let audioEffect = AudioPlayerEffect(rawValue: sender.tag) else {
            return
        }
        
        audioPlayer = AudioPlayer(url: audioURL, audioEffect: audioEffect)
        audioPlayer.delegate = self
        audioPlayer.playAudio()
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        configureUI(state: .notPlaying)
        audioPlayer.stopAudio()
    }
    
    func configureUI(state: AudioPlaybackState) {
     
        switch state {
        case .notPlaying:
            slowButton.isEnabled = true
            fastButton.isEnabled = true
            highPitchButton.isEnabled = true
            lowPitchButton.isEnabled = true
            echoButton.isEnabled = true
            reverbButton.isEnabled = true
            stopButton.isEnabled = false
        case .playing:
            slowButton.isEnabled = false
            fastButton.isEnabled = false
            highPitchButton.isEnabled = false
            lowPitchButton.isEnabled = false
            echoButton.isEnabled = false
            reverbButton.isEnabled = false
            stopButton.isEnabled = true
        case .unknownPlaybackCondition:
            slowButton.isEnabled = false
            fastButton.isEnabled = false
            highPitchButton.isEnabled = false
            lowPitchButton.isEnabled = false
            echoButton.isEnabled = false
            reverbButton.isEnabled = false
            stopButton.isEnabled = false
        }
    }
    
    func configButtonAlignment() {
        // fix button streching on small iOS devices when in landscape
        slowButton.contentMode = .center
        slowButton.imageView?.contentMode = .scaleAspectFit
        highPitchButton.contentMode = .center
        highPitchButton.imageView?.contentMode = .scaleAspectFit
        fastButton.contentMode = .center
        fastButton.imageView?.contentMode = .scaleAspectFit
        lowPitchButton.contentMode = .center
        lowPitchButton.imageView?.contentMode = .scaleAspectFit
        echoButton.contentMode = .center
        echoButton.imageView?.contentMode = .scaleAspectFit
        reverbButton.contentMode = .center
        reverbButton.imageView?.contentMode = .scaleAspectFit
        stopButton.contentMode = .center
        stopButton.imageView?.contentMode = .scaleAspectFit
    }
}
