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
    // ideally this method should throw if audio recording or saving failed
    func stopRecording() async throws -> Recording {
        // check if audioRecorder has recorder audio file and create business model
        guard let recording = try audioRecorder?.stopRecording(),
        let fileUrl = audioRecorder?.fileUrl else {
            // must throw some AudioRecorderError
            print("❌❌❌ Audio recording failed.")
            throw AudioRecorderError.recordingFailed // TODO: This error belongs to Data layer and shouldn't be exposed.
        }
        
        // We need to save the recording and update the UI only in case of success
        do {
            try await audioRepository?.save(recording, fileUrl: fileUrl)
            // update list: if success then we can just add 1 record on top of the list, we don't need to reload the whole list
            return recording
        } catch {
            print("❌❌❌ Save record failed.")
            throw AudioRecorderError.recordingFailed // TODO: This error belongs to Data layer and shouldn't be exposed.
        }
    }
}
