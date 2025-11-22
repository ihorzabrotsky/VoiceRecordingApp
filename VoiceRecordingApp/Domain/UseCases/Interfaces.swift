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
    func stopRecording()
}

protocol AudioPlayer {
    func playRecord()
    func pauseRecord()
    func stopRecord()
}

protocol AudioRepository {
    func saveRecord() async throws
    func loadRecords() async throws -> [Record]
}
