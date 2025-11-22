//
//  MainView.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var records: [Record] = []
    
    func loadRecords() async -> [Record] {
        return [Record(id: 0, text: "Record 111"),
                Record(id: 1, text: "Record 222"),
                Record(id: 2, text: "Record 333")]
    }
}

enum MainViewState {
    case recording
    case playback
}

struct MainView: View {
    @State private var mainViewState: MainViewState = .recording
    @State private var recordings: [Record] = []
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section("Recordings") {
                        ForEach(recordings, id: \.id) { rec in
                            NavigationLink(destination: PlaybackView()) {
                                Text(rec.text)
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
