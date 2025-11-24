//
//  PlaybackView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI
import Combine

enum PlaybackViewState: String {
    case idle = "Play"
    case playing = "Pause"
    case paused = "Resume"
}

final class PlaybackViewModel: ObservableObject {
    @Published var state: PlaybackViewState = .idle
    
    private let playRecordingUseCase = PlayRecordingUseCase()
    
    
}

struct PlaybackView: View {
    @StateObject private var viewModel = PlaybackViewModel()
    
    var body: some View {
        ZStack {
            Text("Playback View")
            
            HStack {
                // Play/Pause button
                Button("\(viewModel.state.rawValue)") {
                    switch viewModel.state {
                    case .idle:
                        viewModel.state = .playing
                        
                    case .playing:
                        viewModel.state = .paused
                        
                    case .paused:
                        viewModel.state = .playing
                    }
                    print("Play/Pause pressed")
                }
                .frame(width: 50, height: 50)
                
                Spacer()
                
                // Stop button
                if viewModel.state != .idle {
                    Button("Stop") {
                        viewModel.state = .idle
                        print("Stop button pressed")
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .frame(width: 120, height: 50)
            .offset(y: 60)
        }
    }
}
