//
//  Recording.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

struct Recording: Identifiable, Hashable {
    let id: UUID
    let title: String
    let duration: Double
    let date: Date
}
