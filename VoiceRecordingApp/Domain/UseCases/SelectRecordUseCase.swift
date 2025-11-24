//
//  SelectRecordUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 21.11.2025.
//

import Foundation

/// When users selects existing Record from the list:
/// 1. Item in List must be selected
/// 2. PlaybackView must be shown to play this record
struct SelectRecordUseCase {
    private let audioPlayer: AudioPlayer = AudioPlayerImpl.shared // TODO: shouldn't be Singleton. Proper DI needed
    private let repository: AudioRepository = AudioRepositoryImpl.shared // TODO: shouldn't be Singleton. Proper DI needed
    
    // TODO: must throw
    func select(_ recording: Recording) {
        // we need to find Recording in Repository by id and pass the url to audioPlayer
        
        guard let url = repository.getRecordingUrl(by: recording.id) else {
            print("❌❌❌ No recording for id: \(recording.id)")
            return
        }
        
        audioPlayer.setActiveRecordingURL(url)
    }
}
