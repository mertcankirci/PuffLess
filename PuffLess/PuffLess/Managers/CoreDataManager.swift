//
//  CoreDataManager.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container = NSPersistentContainer(name: "PuffLess")
    
    private init() {
        container.loadPersistentStores { descriptionn, error in
            if let error = error {
                print("Error loading persistent store: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
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
    
    
    
}