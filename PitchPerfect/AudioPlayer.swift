//
//  AudioPlayer.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/11/21.
//

import AVFoundation

class AudioPlayer {
    
    var delegate: AudioPlayerDelegate!
    
    private let url: URL!
    private let audioEffect: AudioPlayerEffect!
    private var audioFile:AVAudioFile!
    private var audioEngine:AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var stopTimer: Timer!
    
    init(url: URL, audioEffect: AudioPlayerEffect) {
        self.url = url
        self.audioEffect = audioEffect
        
        do {
            audioFile = try AVAudioFile(forReading: self.url as URL)
        } catch {
        }
    }
    
    func playAudio() {

        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        var rate: Float? = nil
        var audioNodes = [AVAudioNode]()
        audioNodes.append(audioPlayerNode)
        
        switch audioEffect {
        case .fast, .slow, .lowPitch, .highPitch:
            print("fast slow low high")
            let changeRatePitchNode = AVAudioUnitTimePitch()
            switch audioEffect {
            case .fast:
                print("fast")
                changeRatePitchNode.rate = 1.5
                rate = 1.5
            case .slow:
                print("slow")
                changeRatePitchNode.rate = 0.5
                rate = 0.5
            case .highPitch:
                print("highPitch")
                changeRatePitchNode.pitch = 1000
            case .lowPitch:
                print("lowPitch")
                changeRatePitchNode.pitch = -1000
            default:
                break
            }
            audioEngine.attach(changeRatePitchNode)
            audioNodes.append(changeRatePitchNode)
        case .echo:
            print("echo")
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)
            audioNodes.append(echoNode)
        case .reverb:
            print("reverb")
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)
            audioNodes.append(reverbNode)
        default:
            break
        }

        audioNodes.append(audioEngine.outputNode)
        
        for index in 0..<(audioNodes.count - 1) {
            audioEngine.connect(audioNodes[index] as AVAudioNode,
                                to: audioNodes[index + 1] as AVAudioNode,
                                format: audioFile.processingFormat)
        }

        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
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
        
        do {
            try audioEngine.start()
            delegate.audioStartedPlaying()
        } catch {
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    @objc func stopAudio() {
        
        delegate.audioFinishedPlaying()

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

