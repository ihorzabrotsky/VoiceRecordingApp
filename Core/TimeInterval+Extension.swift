//
//  TimeInterval+Extension.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 25.11.2025.
//

import Foundation

extension TimeInterval {
    var formatted: String {
        let totalMilliseconds = Int((self*1000).rounded())
        let minutes = totalMilliseconds / 60000
        let seconds = (totalMilliseconds % 60000)/1000
        let milliseconds = (totalMilliseconds % 1000) / 10
        
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}
