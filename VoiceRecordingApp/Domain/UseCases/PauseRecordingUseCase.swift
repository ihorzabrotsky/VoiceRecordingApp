//
//  PauseRecordingUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

struct PauseRecordingUseCase {
    private var audioRecorder: AudioRecorder? // TODO: inject
    
    func pauseRecording() {
        audioRecorder?.pauseRecording()
    }
}
