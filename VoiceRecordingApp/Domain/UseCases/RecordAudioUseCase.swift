//
//  RecordAudioUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

struct RecordAudioUseCase {
    
    private let audioRecorder: AudioRecorder? // TODO: inject
    
    init() {
        audioRecorder = nil
    }
    
    func recordAudio() throws {
        try audioRecorder?.startRecording()
    }
}
