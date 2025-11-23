//
//  MainView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var records: [Recording] = []
    
    func loadRecords() async -> [Recording] {
        return [Recording(id: UUID(), title: "Record 111", duration: 2, date: Date()),
                Recording(id: UUID(), title: "Record 222", duration: 2, date: Date()),
                Recording(id: UUID(), title: "Record 333", duration: 2, date: Date())]
    }
}

enum MainViewState {
    case recording
    case playback
}

struct MainView: View {
    @State private var mainViewState: MainViewState = .recording
    @State private var recordings: [Recording] = []
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section("Recordings") {
                        ForEach(recordings, id: \.id) { rec in
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
                    recordings = await viewModel.loadRecords()
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
                    Button("") {
                        // record
                    }
                    .frame(width: 50, height: 50)
                    .background(.red)
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}
