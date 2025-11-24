//
//  PlaybackView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI
import Combine

enum PlaybackViewState {
    case idle
    case playing
    case paused
}

final class PlaybackViewModel: ObservableObject {
    @Published var state: PlaybackViewState = .idle
    
//    private let 
    
}

struct PlaybackView: View {
    @StateObject private var viewModel = PlaybackViewModel()
    
    var body: some View {
        Text("Playback View")
    }
}
