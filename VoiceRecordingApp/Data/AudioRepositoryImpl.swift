//
//  AudioRepositoryImpl.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import CoreData

final class AudioRepositoryImpl: AudioRepository {
    
    // TODO: we can have a problem of bad syncing of cachedRecordings and those from CoreData. Need to think about that.
    // This array is needed to avoid constant CoreData reloads when we search for a recording with a specific ID
    private var cachedRecordings: [RecordingDTO] = []
    
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
        try CoreDataManager.shared.saveContext()
        cachedRecordings.append(recordingDTO) // append local cache with recordingDTO
    }
    
    func loadRecords() async throws -> [Recording] {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<RecordingEntity> = RecordingEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            print("✅✅✅ Results from CoreData: \(results)")
            let recordingDTOs = results.compactMap { entity -> RecordingDTO? in
                guard let id = entity.id,
                      let url = entity.url,
                      let title = entity.title,
                      let date = entity.date else { return nil }
                return RecordingDTO(id: id,
                                    title: title,
                                    duration: entity.duration,
                                    date: date,
                                    url: url)
            }
            print("✅✅✅ RecordingDTOs loaded successfully: \(recordingDTOs)")
            cachedRecordings = recordingDTOs
            return recordingDTOs.map { $0.convertToRecording() }
        } catch {
            print("❌❌❌ Error loading recordings from CoreData: \(error)")
            return [] // TODO: need to throw
        }
    }
    
    func getRecordingUrl(by id: UUID) -> URL? {
        cachedRecordings.first(where: { recordingDTO in
            recordingDTO.id == id
        })?.url
    }
    
}
