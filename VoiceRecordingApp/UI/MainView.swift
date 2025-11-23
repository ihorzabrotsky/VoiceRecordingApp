//
//  MainView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI

enum MainViewState: String {
    case recording = "Recording"
    case paused = "Resume record"
    case idle = "Record"
}

@MainActor
class MainViewModel: ObservableObject {
    
    private let recordAudioUseCase = RecordAudioUseCase()
    private let pauseRecordingUseCase = PauseRecordingUseCase()
    private let stopRecordingUseCase = StopRecordingUseCase()
    
    @Published var records: [Recording] = []
    @Published var state: MainViewState = .idle
    
    func recordAudio() {
        state = .recording
        do {
            try recordAudioUseCase.recordAudio()
        } catch {
            print("❌❌❌ \(Self.self): audio recording failed: \(error)")
        }
    }
    
    func pauseRecord() {
        state = .paused
        pauseRecordingUseCase.pauseRecording()
        
    }
    
    func stopRecord() {
        state = .idle
        Task {
            do {
                records.insert(try await stopRecordingUseCase.stopRecording(), at: 0)
            } catch {
                // TODO: here we need to handle error and show some error for the user. For this we should update MainViewState with some error state
                print("❌❌❌ \(Self.self): audio recording stop failed, new Record wasn't added to List: \(error)")
            }
        }
    }
    
    func loadRecords() async {
        records = [Recording(id: UUID(), title: "Record 111", duration: 2, date: Date()),
                   Recording(id: UUID(), title: "Record 222", duration: 2, date: Date()),
                   Recording(id: UUID(), title: "Record 333", duration: 2, date: Date())]
    }
}

// TODO
// UX question:
// If user records audio atm -> List has to be blocked. We can show/hide it appropriately
struct MainView: View {
    @State private var mainViewState: MainViewState = .recording
//    @State private var recordings: [Recording] = []
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section("Recordings") {
                        ForEach(viewModel.records, id: \.id) { rec in
                            NavigationLink(destination: PlaybackView()) {
                                Text(rec.title)
                            }
                            .tag(rec)
                        }
                    }
                }
                .listStyle(.sidebar)
                .frame(width: 200)
                .task {
                    await viewModel.loadRecords()
                }
                
                
                
                if mainViewState == .recording {
                    RecordingView(text: "Recording View Title")
                } else {
                    PlaybackView()
                }
            }
            .navigationViewStyle(.columns)
            
            HStack {
                Group {
                    let title = viewModel.state.rawValue
                    Button(title) {
                        switch viewModel.state {
                        case .idle:
                            viewModel.recordAudio()
                            
                        case .recording:
                            viewModel.pauseRecord()
                            
                        case .paused:
                            viewModel.recordAudio()
                        }
                    }
                    .frame(width: 120, height: 50)
                    .background(.red)
                    
                    if viewModel.state != .idle {
                        Button("Stop") {
                            viewModel.stopRecord()
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
