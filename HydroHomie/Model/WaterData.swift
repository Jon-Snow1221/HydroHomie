//
//  WaterData.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import Foundation
import CloudKit

struct HydroStrings {
    static let recordTypeKey = "WaterData"
    fileprivate static let volumeKey = "volume"
    fileprivate static let dateKey = "date"
}

class WaterData {
    var volume: Int
    var date: Date
    var recordID: CKRecord.ID
    
    init(volume: Int, date: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.volume = volume
        self.date = date
        self.recordID = recordID
    }
}// End of class

extension WaterData {
    
    convenience init?(ckRecord: CKRecord) {
        guard let volume = ckRecord[HydroStrings.volumeKey] as? Int,
              let date = ckRecord[HydroStrings.dateKey] as? Date else { return nil }
        self.init(volume: volume, date: date, recordID: ckRecord.recordID)
    }
}// End of extension

extension CKRecord {
    convenience init(waterData: WaterData) {
        self.init(recordType: HydroStrings.recordTypeKey, recordID: waterData.recordID)
        self.setValuesForKeys([
            HydroStrings.volumeKey : waterData.volume,
            HydroStrings.dateKey : waterData.date
        ])
    }
}// End of extension

extension WaterData: Equatable {
    static func == (lhs: WaterData, rhs: WaterData) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}// End of extension

