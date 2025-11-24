//
//  StopPlayingUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 24.11.2025.
//

import Foundation

struct StopPlayingUseCase {
    private let audioPlayer: AudioPlayer? = AudioPlayerImpl() // TODO: Shouldn't be Singleton. Proper DI needed.
    
    func stopPlaying() {
        audioPlayer?.stopPlaying()
    }
}
