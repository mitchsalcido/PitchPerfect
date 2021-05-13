//
//  AudioPlayer.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/11/21.
//
/*
About AudioPlayer.swift
 Class to handle audio playback. Requires url and audio effect which are provided at class initialization. Requires valid delegate.
 */

import AVFoundation

class AudioPlayer {
    
    // ref to delegate
    var delegate: AudioPlayerDelegate!
    
    // url and audioEffect, provided at init
    private let url: URL!
    private let audioEffect: AudioPlayerEffect!
    
    // audio playback properties
    private var audioFile:AVAudioFile!
    private var audioEngine:AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var stopTimer: Timer!   // used for stop playing timer, audio time-out
    
    // designated init, requires url and audio effect
    init(url: URL, audioEffect: AudioPlayerEffect) {
        self.url = url
        self.audioEffect = audioEffect
        do {
            audioFile = try AVAudioFile(forReading: self.url as URL)
        } catch {
            delegate.audioPlayerError(AudioPlayerError.audioFileError)
        }
    }
    
    // play audio
    func playAudio() {

        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // rate used to calculate audio playback time-out in closure below
        var rate: Float? = nil
        
        // create and append nodes. Used to build and connect audio node connections
        var audioNodes = [AVAudioNode]()
        audioNodes.append(audioPlayerNode)
        
        // determine audio effect. Create and attached node and append to audioNodes array
        switch audioEffect {
        case .fast, .slow, .lowPitch, .highPitch:
            let changeRatePitchNode = AVAudioUnitTimePitch()
            switch audioEffect {
            case .fast:
                changeRatePitchNode.rate = 1.5
                rate = 1.5
            case .slow:
                changeRatePitchNode.rate = 0.5
                rate = 0.5
            case .highPitch:
                changeRatePitchNode.pitch = 1000
            case .lowPitch:
                changeRatePitchNode.pitch = -1000
            default:
                break
            }
            audioEngine.attach(changeRatePitchNode)
            audioNodes.append(changeRatePitchNode)
        case .echo:
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)
            audioNodes.append(echoNode)
        case .reverb:
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)
            audioNodes.append(reverbNode)
        default:
            break
        }

        // output node
        audioNodes.append(audioEngine.outputNode)
        
        // connect nodes
        for index in 0..<(audioNodes.count - 1) {
            audioEngine.connect(audioNodes[index] as AVAudioNode,
                                to: audioNodes[index + 1] as AVAudioNode,
                                format: audioFile.processingFormat)
        }

        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            // completion. Create timer to time-out audio playback
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
        
        // start audio
        do {
            try audioEngine.start()
        } catch {
            delegate.audioPlayerError(AudioPlayerError.audioEngineError)
            return
        }
        
        // play audio
        audioPlayerNode.play()
    }
    
    // stop audio
    @objc func stopAudio() {
        
        // inform delegate end of audio
        delegate.audioFinishedPlaying()
        
        // stop audio and timer
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
}

