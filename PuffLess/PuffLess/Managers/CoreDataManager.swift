//
//  CoreDataManager.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import WidgetKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container = NSPersistentContainer(name: "PuffLess")
    
    private init() {
        let url = URL.storeUrl(for: "group.com.mertcankirci.PuffLess", databaseName: "PuffLess")
        let storeDescription = NSPersistentStoreDescription(url: url)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading persistent store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
#if DEBUG
                print("Error saving context: \(error)")
#endif
            }
        }
    }
    
    func addCigaretteLog(quantity: Int16, date: Date = Date()) {
        let log = CigaretteLog(context: context)
        log.date = date
        log.quantitiy = quantity
        log.id = UUID()
        saveContext()
    }
    
    func fetchCigaretteLogs() -> [CigaretteLog] {
        let request: NSFetchRequest<CigaretteLog> = CigaretteLog.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
#if DEBUG
            print("error fetching cigarette logs: \(error)")
#endif
            return []
        }
    }
    
    func deleteCigaretteLog(_ log: CigaretteLog) {
        context.delete(log)
        saveContext()
    }
    
    func deleteAllLogs() {
        let request: NSFetchRequest<NSFetchRequestResult> = CigaretteLog.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
#if DEBUG
            print("error deleting all logs: \(error)")
#endif
        }
    }
    
    //Widget icin 
    
    func returnDailyGoal() -> Int {
        guard let defaults = UserDefaults(suiteName: "group.com.mertcankirci.PuffLess") else { return 0}
        return defaults.integer(forKey: "dailyGoal")
    }
    
    
}


public extension URL {
    static func storeUrl(for appGroup: String, databaseName: String) -> URL {
        guard let fileContianer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL")
        }
        return fileContianer.appendingPathComponent("\(databaseName).sqlite")
    }
}
