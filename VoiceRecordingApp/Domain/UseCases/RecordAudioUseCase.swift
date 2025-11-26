//
//  RecordAudioUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

struct RecordAudioUseCase {
    
    private let audioRecorder: AudioRecorder? = AudioRecorderImpl1.shared // TODO: inject
    
    func recordAudio(_ onDurationUpdate: @escaping AudioRecorder.DurationUpdater) throws {
        try audioRecorder?.startRecording(onDurationUpdate)
    }
}
