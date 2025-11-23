//
//  RecordingView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI
import Combine

enum RecordingState: String {
    case recording = "Recording"
    case paused = "Paused"
    case idle = "Start recording"
}

@MainActor
class RecordingViewModel: ObservableObject {
    
    private let recordAudioUseCase = RecordAudioUseCase()
    private let stopRecordingUseCase = StopRecordingUseCase()
    
    @Published var state = RecordingState.idle
    
    init() {
        
    }
    
    func startRecord() {
        do {
            try recordAudioUseCase.recordAudio()
            state = .recording
            
            // start recording timer
            // show Stop button
        } catch {
            print("❌ Audio recording hasn't started.")
        }
    }
    
    func pauseRecord() {
        // TODO: implement pause recording
        // pause timer
        state = .paused
    }
    
    func stopRecord() async throws {
        let recording = try await stopRecordingUseCase.stopRecording()
        state = .idle
        // remove timer
    }
}

struct RecordingView: View {
    @State private var title: String
    @StateObject private var viewModel = RecordingViewModel()
    
    init(text: String) {
        self.title = text
    }
    
    @State private var showLowerText: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .background(.yellow)
                
                let title = viewModel.state.rawValue
                
                Button(title) {
                    switch viewModel.state {
                    case .idle:
                        viewModel.startRecord()
                        
                    case .recording:
                        viewModel.pauseRecord()
                        
                    case .paused:
                        viewModel.startRecord() // TODO: need to rethink continue of interrupted record
                    }
                }
            }
            
            if viewModel.state != .idle {
                Button("Stop!") {
                    viewModel.state = .idle
                    Task {
                        try await viewModel.stopRecord()
                    }
                }
                .offset(y: 40)
            }
        }
        .frame(minWidth: 200,  maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
    }
    
}
