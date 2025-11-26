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
    private let importCachedRecordingsUseCase = ImportCachedRecordingsUseCase()
    private let selectRecordUseCase = SelectRecordUseCase()
    
    @Published var records: [Recording] = []
    @Published var state: MainViewState = .idle
    @Published var selection: UUID? // need this to properly customize List item selection
    @Published var duration: TimeInterval = 0
    
    func recordAudio() {
        state = .recording
        do {
            try recordAudioUseCase.recordAudio { [weak self] newDuration in
                guard let self = self else { return }
                self.duration = newDuration
            }
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
        do {
            records = try await importCachedRecordingsUseCase.loadRecordings()
        } catch {
            print("❌❌❌ \(Self.self): loading list of saved recordings failed: \(error)")
        }
    }
    
    func select(recording: Recording) {
        selection = recording.id
        selectRecordUseCase.select(recording)
        print("⚠️⚠️⚠️ Just tapped on Recording")
    }
}

// TODO
// UX question:
// If user records audio atm -> List has to be blocked. We can show/hide it appropriately
struct MainView: View {
    @State private var mainViewState: MainViewState = .recording
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List(selection: $viewModel.selection) {
                    Section("Recordings") {
                        ForEach(viewModel.records, id: \.id) { rec in
                            NavigationLink(destination: PlaybackView(), tag: rec.id, selection: $viewModel.selection) {
                                VStack {
                                    HStack {
                                        Text(rec.title)
                                            .font(.title2)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(rec.date, format: .dateTime.day().month().year().hour().minute())
                                        Spacer()
                                    }
                                    HStack {
                                        // TODO: move to viewModel
                                        Text("\((Int(rec.duration)/60).formatted(.number.precision(.integerLength(1...2))))m \((Int(rec.duration) - Int(rec.duration/60)*60).formatted(.number.precision(.integerLength(1...2))))s")
                                        Spacer()
                                    }
                                    Divider()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.select(recording: rec)
                                }
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            
            // This is actual RecordingView
            HStack {
                Group {
                    let title = viewModel.state.rawValue
                    Button {
                        switch viewModel.state {
                        case .idle:
                            viewModel.recordAudio()
                            
                        case .recording:
                            viewModel.pauseRecord()
                            
                        case .paused:
                            viewModel.recordAudio()
                        }
                    } label: {
                        Text(title)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 120, height: 50)
                    .buttonStyle(BorderlessButtonStyle())
                    .background(.red)
                    .contentShape(Rectangle())
                    
                    if viewModel.state != .idle {
                        HStack {
                            Button {
                                viewModel.stopRecord()
                            } label: {
                                Text("Stop")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(width: 70, height: 50)
                            .buttonStyle(BorderlessButtonStyle())
                            .background(.blue)
                            .contentShape(Rectangle())
                            
                            Text("\(viewModel.duration.formatted)")
                                .font(.title2)
                                .frame(width: 100)
                        }
                    }
                    
                    
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
