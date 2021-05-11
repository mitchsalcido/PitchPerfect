//
//  PlaybackAudioViewController.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/10/21.
//

import UIKit
import AVFoundation

class PlaybackAudioViewController: UIViewController {

    var audioURL: URL!

    @IBOutlet var fastButton: UIButton!
    @IBOutlet var slowButton: UIButton!
    @IBOutlet var highPitchButton: UIButton!
    @IBOutlet var lowPitchButton: UIButton!
    @IBOutlet var echoButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
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
        
        // Do any additional setup after loading the view.
        configButtonAlignment()
        
        setupAudio()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        //let effect = AudioEffect(rawValue: sender.tag)
        guard let effect = AudioEffect(rawValue: sender.tag) else {
            return
        }
        
        switch effect {
        case .fast:
            playSound(rate: 1.5)
        case .slow:
            playSound(rate: 0.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(state: .playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
        configureUI(state: .notPlaying)
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
