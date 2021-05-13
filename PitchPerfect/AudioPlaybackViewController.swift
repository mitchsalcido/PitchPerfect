//
//  AudioPlaybackViewController.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//
/*
About AudioPlaybackViewController.swift
 UIViewController subclass to handle starting and stopping audio playback and selecting effect to apply to audio.
 */

import UIKit
import AVFoundation

class AudioPlaybackViewController: UIViewController, AudioPlayerDelegate {
    
    // reference to audio url to be played back
    var audioURL: URL!

    // UI elements
    @IBOutlet var fastButton: UIButton!
    @IBOutlet var slowButton: UIButton!
    @IBOutlet var highPitchButton: UIButton!
    @IBOutlet var lowPitchButton: UIButton!
    @IBOutlet var echoButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    // reference to AudioPlayer class. Handles details of audio playback
    var audioPlayer: AudioPlayer!
    
    // enum of playback state. Used to steer UI enable/disable states
    enum AudioPlaybackState {
        case playing
        case notPlaying
        case unknownPlaybackCondition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navbar title and UI config
        title = "PitchPerfect - Playback"
        configureUI(state: .notPlaying)
        configButtonAlignment() // needed for smaller iOS devices to maintain proper object view aspect
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop audio when view disappears
        audioPlayer.stopAudio()
    }
    
    // play button pressed
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        // config UI and start the audio
        configureUI(state: .playing)
        guard let audioEffect = AudioPlayerEffect(rawValue: sender.tag) else {
            return
        }
        audioPlayer = AudioPlayer(url: audioURL, audioEffect: audioEffect)
        audioPlayer.delegate = self
        audioPlayer.playAudio()
    }
    
    // stop button pressed
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        // config UI and stop the audio
        configureUI(state: .notPlaying)
        audioPlayer.stopAudio()
    }
    
    // helper function to set the view UI objects
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
    
    // helper function to set aspect fit of view UI objects
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
    
    // MARK: AudioPlayerDelegate Functions
    func audioFinishedPlaying() {
        
        // done playing.
        configureUI(state: .notPlaying)
    }
    
    func audioPlayerError(_ error: AudioPlayerError) {
        
        // playback error. Place UI in known state and show alert
        configureUI(state: .unknownPlaybackCondition)
        self.showAlert(error)
    }
}
