//
//  AudioPlayer-Constants.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/11/21.
//

import Foundation

protocol AudioPlayerDelegate {
    func audioStartedPlaying()
    func audioFinishedPlaying()
    func audioPlayerError(_ error: AudioPlayerError)
}

enum AudioPlayerEffect: Int {
    case fast = 0
    case slow
    case highPitch
    case lowPitch
    case echo
    case reverb
}

enum AudioPlayerError: LocalizedError {
    case audioEngineError
    case audioNodeError
    
    var errorDescription: String? {
        
        switch self {
        case .audioEngineError:
            return "AudioEngine Failure"
        case .audioNodeError:
            return "AudioNode Failure"
        }
    }
    
    var failureReason: String? {
        return "Contact the App store for prompt and courteous service"
    }
    
    var helpAnchor: String? {
        return nil
    }
    
    var recoverySuggestion: String? {
        return "Dismiss"
    }
}
