//
//  WaterData.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import Foundation
import CloudKit

/**
 Creating a struct named HydroStrings containing the String values for keys used when setting the values for a CKRecord.
 */
struct HydroStrings {
    static let recordTypeKey = "WaterData"
    fileprivate static let volumeKey = "volume"
    fileprivate static let dateKey = "date"
    fileprivate static let goalKey = "goal"
}

class WaterData {
    var volume: Int
    var date: Date
    var goal: Int
    var recordID: CKRecord.ID
    
    init(volume: Int, date: Date = Date(), goal: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.volume = volume
        self.date = date
        self.goal = goal
        self.recordID = recordID
    }
}// End of class

extension WaterData {
    
    convenience init?(ckRecord: CKRecord) {
        guard let volume = ckRecord[HydroStrings.volumeKey] as? Int,
              let date = ckRecord[HydroStrings.dateKey] as? Date,
              let goal = ckRecord[HydroStrings.goalKey] as? Int else { return nil }
        self.init(volume: volume, date: date, goal: goal, recordID: ckRecord.recordID)
    }
}// End of extension

extension CKRecord {
    /**
    Convenience Initializer to create a CKRecord from an Entry object
    
    - Parameters:
     - entry: The Entry object to set Key/Value pairs to store inside a CKRecord
    */
    
    convenience init(waterData: WaterData) {
        self.init(recordType: HydroStrings.recordTypeKey, recordID: waterData.recordID)
        self.setValuesForKeys([
            HydroStrings.volumeKey : waterData.volume,
            HydroStrings.dateKey : waterData.date,
            HydroStrings.goalKey : waterData.goal
        ])
    }
}// End of extension

extension WaterData: Equatable {
    static func == (lhs: WaterData, rhs: WaterData) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}// End of extension

