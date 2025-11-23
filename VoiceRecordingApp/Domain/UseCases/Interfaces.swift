//
//  Interfaces.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 21.11.2025.
//

import Foundation

protocol AudioRecorder {
    func startRecording() throws
    func pauseRecording()
    // "stopRecording" doesn't reflect the fact that Recording will be returned but this is done atm to save time.
    func stopRecording() throws -> Recording
    
    var fileUrl: URL? { get }
}

protocol AudioPlayer {
    func playRecord()
    func pauseRecord()
    func stopRecord()
}

protocol AudioRepository {
    func save(_ recording: Recording, fileUrl: URL) async throws
    func loadRecords() async throws -> [Recording]
}
