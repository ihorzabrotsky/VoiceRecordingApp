//
//  PausePlayingUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation

struct PausePlayingUseCase {
    private let audioPlayer: AudioPlayer = AudioPlayerImpl.shared // TODO: Shouldn't be Singleton. Proper DI needed.
    
    func pausePlaying() {
        audioPlayer.pausePlaying()
    }
}
