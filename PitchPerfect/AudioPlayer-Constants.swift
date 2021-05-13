//
//  AudioPlayer-Constants.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/11/21.
//
/*
About AudioPlayer-Constants.swift
 Protocol and eums used in AudioPlayer class
 */

import Foundation

// protocol to handle playback events
protocol AudioPlayerDelegate {
    func audioFinishedPlaying() // finished playing audio
    func audioPlayerError(_ error: AudioPlayerError)  // audio playback error
}

// enum for playback effects
enum AudioPlayerEffect: Int {
    case fast = 0
    case slow
    case highPitch
    case lowPitch
    case echo
    case reverb
}

// enum for errors unique to AudioPlayer class
enum AudioPlayerError: LocalizedError {
    case audioEngineError
    case audioNodeError
    case audioFileError
    
    var errorDescription: String? {
        
        switch self {
        case .audioEngineError:
            return "Error with audio engine"
        case .audioNodeError:
            return "Error with audio node"
        case .audioFileError:
            return "Error with audio file"
        }
    }
    
    var helpAnchor: String? {
        return "Dissmiss"
    }
    
    var recoverySuggestion: String? {
        return "Contact the App store for prompt and courteous service"
    }
}
