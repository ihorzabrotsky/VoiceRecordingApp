//
//  Interfaces.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 21.11.2025.
//

import Foundation

protocol AudioRecorder {
    typealias DurationUpdater = (TimeInterval) -> Void
    func startRecording(_ onDurationUpdateCompletion: @escaping DurationUpdater) throws
    func pauseRecording()
    // "stopRecording" doesn't reflect the fact that Recording will be returned but this is done atm to save time.
    func stopRecording() throws -> Recording
    
    var fileUrl: URL? { get }
}

protocol AudioPlayer {
    typealias OnStopCompletion = (Bool) -> Void
    
    func playRecord(_ onStopCompletion: @escaping OnStopCompletion)
    func pausePlaying()
    func stopPlaying()
    // TODO: we can work only with Data type for recordings. Would be good to refactor so AudioPlayer and AudioRecorder don't know about URLs at all
    func setActiveRecordingURL(_ url: URL)
}

protocol AudioRepository {
    // Not sure about the need of exposing of URL to business layer. I think this should not be here.
    // But AVAudioRecorder tied with URL for saving audio file.
    // Maybe, it can also work without URL - need to investigate if have time.
    func save(_ recording: Recording, fileUrl: URL) async throws
    func loadRecords() async throws -> [Recording]
    
    // Need this method for playing
    func getRecordingUrl(by id: UUID) -> URL? // should it throw?
}
