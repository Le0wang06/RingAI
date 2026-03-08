//
//  DatabaseService.swift
//  ScamShield
//
//  Local database management with Core Data
//

import Foundation
import CoreData

// MARK: - Database Service
class DatabaseService {
    static let shared = DatabaseService()
    
    // Core Data container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ScamShield")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Check if Number is Known Scam
    func isKnownScam(_ phoneNumber: String) -> Bool {
        let request: NSFetchRequest<ScamNumberEntity> = ScamNumberEntity.fetchRequest()
        request.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking scam number: \(error)")
            return false
        }
    }
    
    // MARK: - Add Scam Number
    func addScamNumber(phoneNumber: String, scamType: String, reportCount: Int) {
        let scamNumber = ScamNumberEntity(context: context)
        scamNumber.phoneNumber = phoneNumber
        scamNumber.scamType = scamType
        scamNumber.reportCount = Int32(reportCount)
        scamNumber.lastReported = Date()
        
        saveContext()
    }
    
    // MARK: - Save to History
    func saveToHistory(result: PhoneNumberResult) {
        let history = CallHistoryEntity(context: context)
        history.id = UUID()
        history.phoneNumber = result.phoneNumber
        history.scamScore = Int16(result.scamScore)
        history.isScam = result.isScam
        history.location = result.location
        history.checkedAt = Date()
        
        saveContext()
    }
    
    // MARK: - Fetch History
    func fetchHistory(limit: Int = 100) -> [CallLog] {
        let request: NSFetchRequest<CallHistoryEntity> = CallHistoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "checkedAt", ascending: false)]
        request.fetchLimit = limit
        
        do {
            let results = try context.fetch(request)
            return results.map { entity in
                CallLog(
                    phoneNumber: entity.phoneNumber ?? "",
                    scamScore: Int(entity.scamScore),
                    isScam: entity.isScam,
                    location: entity.location,
                    checkedAt: entity.checkedAt ?? Date()
                )
            }
        } catch {
            print("Error fetching history: \(error)")
            return []
        }
    }
    
    // MARK: - Delete History Item
    func deleteHistoryItem(phoneNumber: String, checkedAt: Date) {
        let request: NSFetchRequest<CallHistoryEntity> = CallHistoryEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "phoneNumber == %@ AND checkedAt == %@",
            phoneNumber, checkedAt as NSDate
        )
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting history item: \(error)")
        }
    }
    
    // MARK: - Clear All History
    func clearHistory() {
        let request: NSFetchRequest<NSFetchRequestResult> = CallHistoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error clearing history: \(error)")
        }
    }
    
    // MARK: - Load Scam Numbers from CSV
    func loadScamNumbersFromCSV(filename: String) {
        guard let filepath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let contents = try String(contentsOfFile: filepath)
            let lines = contents.components(separatedBy: .newlines)
            
            // Skip header line
            for line in lines.dropFirst() {
                let fields = line.components(separatedBy: ",")
                guard fields.count >= 4 else { continue }
                
                let phoneNumber = fields[0].trimmingCharacters(in: .whitespaces)
                let scamType = fields[3].trimmingCharacters(in: .whitespaces)
                let reportCount = Int(fields[2].trimmingCharacters(in: .whitespaces)) ?? 0
                
                addScamNumber(
                    phoneNumber: phoneNumber,
                    scamType: scamType,
                    reportCount: reportCount
                )
            }
            
            print("Loaded scam numbers from CSV")
        } catch {
            print("Error loading CSV: \(error)")
        }
    }
    
    // MARK: - Add to Blocklist
    func addToBlocklist(phoneNumber: String, note: String = "") {
        let blocked = BlockedNumberEntity(context: context)
        blocked.phoneNumber = phoneNumber
        blocked.note = note
        blocked.addedAt = Date()
        
        saveContext()
    }
    
    // MARK: - Remove from Blocklist
    func removeFromBlocklist(phoneNumber: String) {
        let request: NSFetchRequest<BlockedNumberEntity> = BlockedNumberEntity.fetchRequest()
        request.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error removing from blocklist: \(error)")
        }
    }
    
    // MARK: - Check if Blocked
    func isBlocked(_ phoneNumber: String) -> Bool {
        let request: NSFetchRequest<BlockedNumberEntity> = BlockedNumberEntity.fetchRequest()
        request.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking blocked number: \(error)")
            return false
        }
    }
}

// MARK: - Core Data Entities (Create these in Xcode Data Model Editor)

/*
 Create a new Data Model file named "ScamShield.xcdatamodeld"
 with the following entities:
 
 1. ScamNumberEntity
    - phoneNumber: String
    - scamType: String
    - reportCount: Int32
    - lastReported: Date
 
 2. CallHistoryEntity
    - id: UUID
    - phoneNumber: String
    - scamScore: Int16
    - isScam: Bool
    - location: String (optional)
    - checkedAt: Date
 
 3. BlockedNumberEntity
    - phoneNumber: String
    - note: String (optional)
    - addedAt: Date
*/

// MARK: - Placeholder Entity Classes (will be auto-generated by Core Data)
@objc(ScamNumberEntity)
class ScamNumberEntity: NSManagedObject {
    @NSManaged var phoneNumber: String?
    @NSManaged var scamType: String?
    @NSManaged var reportCount: Int32
    @NSManaged var lastReported: Date?
}

@objc(CallHistoryEntity)
class CallHistoryEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var phoneNumber: String?
    @NSManaged var scamScore: Int16
    @NSManaged var isScam: Bool
    @NSManaged var location: String?
    @NSManaged var checkedAt: Date?
}

@objc(BlockedNumberEntity)
class BlockedNumberEntity: NSManagedObject {
    @NSManaged var phoneNumber: String?
    @NSManaged var note: String?
    @NSManaged var addedAt: Date?
}
