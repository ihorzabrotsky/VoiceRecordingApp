//
//  StopRecordingUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

// We need to add Publisher for this use case and make it class because we also need to update Records List
struct StopRecordingUseCase {
    private var audioRecorder: AudioRecorder? = AudioRecorderImpl1.shared // TODO: inject
    private var audioRepository: AudioRepository? // TODO: inject
    
    // By User flow design the record must be automatically saved after "Stop".
    // This is behaviour for native Voice Memo (can be changed)
    func stopRecording() {
        audioRecorder?.stopRecording()
        
        Task {
            do {
                try await audioRepository?.saveRecord(/* RECORD */)
                // update list
            } catch {
                print("❌ Save record failed")
            }
        }
    }
}
