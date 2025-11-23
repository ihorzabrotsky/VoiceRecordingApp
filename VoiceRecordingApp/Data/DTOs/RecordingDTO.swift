//
//  RecordingDTO.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation

struct RecordingDTO {
    let id: UUID
    let title: String
    let duration: Double
    let date: Date
    let url: URL
    
    init(id: UUID, title: String, duration: Double, date: Date, url: URL) {
        self.id = id
        self.title = title
        self.duration = duration
        self.date = date
        self.url = url
    }
    
    init(recording: Recording, url: URL) {
        self.id = recording.id
        self.title = recording.title
        self.duration = recording.duration
        self.date = recording.date
        self.url = url
    }
}

extension RecordingDTO {
    func convertToRecording() -> Recording {
        Recording(id: self.id,
                  title: self.title,
                  duration: self.duration,
                  date: self.date)
    }
}
