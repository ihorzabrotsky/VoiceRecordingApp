//
//  PlayRecordingUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

struct PlayRecordingUseCase {
    private let player: AudioPlayer = AudioPlayerImpl.shared
    
    // How to handle this?
    // should we pass Recording itself?
    // if we pass id - we had to obtain it from Recording, of course.
    // What is UX?
    // For VoiceMemo when we press on some Record, obviously, we do remember what Record exactly we pressed on. We can memorize it, right?
    // So... it would be convenient if List knew what is selected - this way we can obtain specific Record and move on with it
    // Wait, no.
    // Selecting a Record from the List is Use Case itself
    // so
    // it must be handled separately - we just need to remember the record we pressed
    func play(_ onStopCompletion: @escaping AudioPlayer.OnStopCompletion, _ onDurationUpdateCompletion: @escaping AudioPlayer.DurationUpdater) {
        player.playRecord(onStopCompletion, onDurationUpdateCompletion)
    }
}
