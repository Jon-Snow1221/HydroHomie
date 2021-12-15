//
//  WaterDataController.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import Foundation
import CloudKit


class WaterDataController {
    
    static let shared = WaterDataController()
    
    //SOT
    var entries: [WaterData] = []
    var dailyWaterEntry: WaterData?
    var dailyGoal: Int = 0
    
    //Property
    let privateDB = CKContainer.default().privateCloudDatabase

    //CRUD
    
    //Create
    func saveEntry(with volume: Int, completion: @escaping (Result<String, HydroError>) -> Void) {
        let newEntry = WaterData(volume: volume, goal: dailyGoal)
        let entryRecord = CKRecord(waterData: newEntry)
        privateDB.save(entryRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            guard let record = record,
                let savedEntry = WaterData(ckRecord: record)
            else { return completion(.failure(.couldNotUnwrap))}

            self.dailyWaterEntry = savedEntry
            completion(.success("Successfully added water entry!"))
        }
    }
    
    //Fetch
    func fetchEntries(completion: @escaping (Result<String, HydroError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HydroStrings.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            var entries = records.compactMap({ WaterData(ckRecord: $0) })
            
            entries.sort(by: { $0.date > $1.date }) //sorts entries in chronological order
            if let first = entries.first {
                if Calendar.current.isDate(first.date, inSameDayAs: Date()) {
                    self.dailyWaterEntry = first
                    entries.removeFirst()
                }
            }
            self.entries = entries
            completion(.success("Successfully fetched Water entries!"))
        }
    }
    
    //Update
    func updateEntry(for waterData: WaterData, with volume: Int, completion: @escaping (Result<String, HydroError>) -> Void) {
        waterData.volume += volume
        let record = CKRecord(waterData: waterData)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive //Happens immediately
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            guard let record = records?.first,
                  let updatedEntry = WaterData(ckRecord: record) else { return  completion(.failure(.couldNotUnwrap)) }
            self.dailyWaterEntry = updatedEntry
            completion(.success("Successfully updated Water entry!"))
        }
        privateDB.add(operation)
    }
    
    func updateGoalForEntry(with goal: Int, waterData: WaterData, completion: @escaping (Result<String, HydroError>) -> Void) {
        waterData.goal = goal
        let record = CKRecord(waterData: waterData)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive //Happens immediately
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            guard let record = records?.first,
                  let updatedEntry = WaterData(ckRecord: record) else { return  completion(.failure(.couldNotUnwrap)) }
            self.dailyWaterEntry = updatedEntry
            completion(.success("Successfully updated Water entry!"))
        }
        privateDB.add(operation)
    }
    
    func updateDailyGoal(with goal: Int) {
        self.dailyGoal = goal
        saveToPersistenceStore()
    }
    
    //MARK: - PERSISTENCE
        func createPersistenceStore() -> URL {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileURL = url[0].appendingPathComponent("HydroHomie.json") // <# # close bracket for placeholder
            return fileURL
        }
        
        //Save
        func saveToPersistenceStore() {
            let jsonEncoder = JSONEncoder()
            do {
                let data = try jsonEncoder.encode(dailyGoal) //only saving the dailyGoal to local persistence
                try data.write(to: createPersistenceStore())
                print("Saved data successfully.")
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        //Load
        func loadFromPersistenceStore() {
            do {
                let data = try Data(contentsOf: createPersistenceStore())
                dailyGoal = try JSONDecoder().decode(Int.self, from: data)
                print("Loaded data successfully.")
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
}// End of class
