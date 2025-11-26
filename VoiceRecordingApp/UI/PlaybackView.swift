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
    @Published var playingDuration: TimeInterval = 0
    
    private let playRecordingUseCase = PlayRecordingUseCase()
    private let pausePlayingUseCase = PausePlayingUseCase()
    private let stopPlayingUseCase = StopPlayingUseCase()
    
    func playRecording() {
        state = .playing
        playRecordingUseCase.play( { [weak self] success in
            if !success {
                // show error
            }
            
            // Let's change the state independently from success for now
            guard let self = self else { return }
            self.state = .idle
        }, { [weak self] duration in
            guard let self = self else { return }
            self.playingDuration = duration
        })
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
                Button {
                    switch viewModel.state {
                    case .idle:
                        viewModel.playRecording()
                        
                    case .playing:
                        viewModel.pausePlaying()
                        
                    case .paused:
                        viewModel.playRecording()
                    }
                    print("Play/Pause pressed")
                } label: {
                    Text("\(viewModel.state.rawValue)")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 70, height: 70)
                .buttonStyle(BorderlessButtonStyle())
                .background(.orange)
                .contentShape(Rectangle())
                
                Spacer()
                
                // Stop button
                if viewModel.state != .idle {
                    Button {
                        viewModel.stopPlaying()
                        print("Stop button pressed")
                    } label: {
                        Text("Stop")
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                    }
                    .frame(width: 70, height: 70)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(.blue)
                    .contentShape(Rectangle())
                    
                    // Timer
                    Text("\(viewModel.playingDuration.formatted)")
                        .font(.title2)
                        .frame(width: 100)
                }
            }
            .frame(width: 160, height: 70)
            .offset(y: 60)
        }
    }
}
