//
//  AudioRecorder-Constants.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/13/21.
//

import Foundation

protocol AudioRecorderDelegate {
    func audioFinishedRecording(url: URL)
    func audioRecorderError(_ error: AudioRecorderError)
}

enum AudioRecorderError: LocalizedError {
    case audioFilepathError
    case audioSessionError
    case audioRecorderError
    
    var errorDescription: String? {
        
        switch self {
        case .audioFilepathError:
            return "Error with audio file path"
        case .audioSessionError:
            return "Error with audio session"
        case .audioRecorderError:
            return "Error with audio recorder"
        }
    }
    
    var helpAnchor: String? {
        return "Dismiss"
    }
    
    var recoverySuggestion: String? {
        return "Contact the App store for prompt and courteous service"
    }
}
