//
//  CoreDataManager.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "AudioRecordingModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("❌❌❌ Failed to load persistent stores: \(error)") // TODO: For testing purposes
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // TODO: need to throw and handle errors in future
    func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
