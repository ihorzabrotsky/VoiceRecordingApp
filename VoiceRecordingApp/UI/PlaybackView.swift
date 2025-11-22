//
//  PlaybackView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI
import Combine

class PlaybackViewModel: ObservableObject {
    
}

enum PlaybackViewState {
    case idle
    case playing
    case paused
}

struct PlaybackView: View {
    var body: some View {
        Text("Playback View")
    }
}
