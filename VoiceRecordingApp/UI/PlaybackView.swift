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

@MainActor
final class PlaybackViewModel: ObservableObject {
    @Published var state: PlaybackViewState = .idle
    
    private let playRecordingUseCase = PlayRecordingUseCase()
    private let pausePlayingUseCase = PausePlayingUseCase()
    private let stopPlayingUseCase = StopPlayingUseCase()
    
    func playRecording() {
        state = .playing
        playRecordingUseCase.play { [weak self] success in
            if !success {
                // show error
            }
            
            // Let's change the state independently from success for now
            guard let self = self else { return }
            self.state = .idle
        }
    }
    
    func pausePlaying() {
        state = .paused
        pausePlayingUseCase.pausePlaying()
    }
    
    func stopPlaying() {
        stopPlayingUseCase.stopPlaying()
    }
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
                        viewModel.playRecording()
                        
                    case .playing:
                        viewModel.pausePlaying()
                        
                    case .paused:
                        viewModel.playRecording()
                    }
                    print("Play/Pause pressed")
                }
                .frame(width: 50, height: 50)
                
                Spacer()
                
                // Stop button
                if viewModel.state != .idle {
                    Button("Stop") {
                        viewModel.stopPlaying()
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
