//
//  ImportCachedRecordingsUseCase.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 20.11.2025.
//

import Foundation

enum ImportCachedError: Error {
    case loadFailed
}

struct ImportCachedRecordingsUseCase {
    private let audioRepository: AudioRepository? = AudioRepositoryImpl.shared
    
    func loadRecordings() async throws -> [Recording] {
        guard let recordings = try await audioRepository?.loadRecords() else {
            throw ImportCachedError.loadFailed
        }
        
        return recordings.sorted { $0.date > $1.date } // we do sort our records from newest to oldest. This is business logic
    }
}
