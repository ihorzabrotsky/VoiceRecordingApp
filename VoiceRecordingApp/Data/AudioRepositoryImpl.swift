//
//  AudioRepositoryImpl.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import CoreData

final class AudioRepositoryImpl: AudioRepository {
    
    static let shared = AudioRepositoryImpl() // TODO: shouldn't be Singleton. Need proper DI in future
    
    func save(_ recording: Recording, fileUrl: URL) async throws {
        let recordingDTO = RecordingDTO(recording: recording, url: fileUrl)
        let context = CoreDataManager.shared.context
        let entity = RecordingEntity(context: context)
        
        entity.id = recordingDTO.id
        entity.title = recordingDTO.title
        entity.duration = recordingDTO.duration
        entity.date = recordingDTO.date
        entity.url = recordingDTO.url
        
        print("Saving entity with id: \(recordingDTO.id)")
        CoreDataManager.shared.saveContext()
    }
    
    func loadRecords() async throws -> [Recording] {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<RecordingEntity> = RecordingEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            print("✅✅✅ Results from CoreData: \(results)")
            let recordings = results.compactMap { entity -> Recording? in
                guard let id = entity.id,
                      let url = entity.url,
                      let title = entity.title,
                      let date = entity.date else { return nil }
                return RecordingDTO(id: id,
                                    title: title,
                                    duration: entity.duration,
                                    date: date,
                                    url: url)
                .convertToRecording()
            }
            print("✅✅✅ Recordings loaded successfully: \(recordings)")
            return recordings
        } catch {
            print("❌❌❌ Error loading recordings from CoreData: \(error)")
            return [] // TODO: need to throw
        }
    }
    
    func getRecordingUrl(by id: UUID) -> URL? {
        nil // TODO: implement
    }
    
}
